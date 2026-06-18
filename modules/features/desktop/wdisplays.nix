{inputs, ...}: {
  flake.homeModules.wdisplays = {pkgs, ...}: let
    hyprlandPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    realHyprctl = "${hyprlandPkg}/bin/hyprctl";

    saveMonitors = pkgs.writeShellScriptBin "hypr-save-monitors" ''
      ${realHyprctl} -j monitors | ${pkgs.python3}/bin/python3 -c "
      import json, sys
      for m in json.load(sys.stdin):
          n = m['name']
          if m.get('disabled'):
              print(f'monitor={n},disable')
              continue
          w, h = m['width'], m['height']
          r = m['refreshRate']
          x, y = m['x'], m['y']
          s = m['scale']
          line = f'monitor={n},{w}x{h}@{r},{x}x{y},{s}'
          if m.get('mirrorOf', 'none') != 'none':
              line += f',mirror,{m[\"mirrorOf\"]}'
          print(line)
      " > ~/.config/hypr/monitors.conf
      echo "Saved to ~/.config/hypr/monitors.conf"
    '';

    mirrorToggle = pkgs.writeShellScriptBin "hypr-mirror-toggle" ''
      py=${pkgs.python3}/bin/python3
      rofi=${pkgs.rofi}/bin/rofi
      notify=${pkgs.libnotify}/bin/notify-send
      conf="$HOME/.config/hypr/monitors.conf"
      state="$HOME/.config/hypr/.mirror-state"
      sep="<────────────────────────>"

      # Shared dark base; accent color varies per step
      rofi_base=(
        -theme-str 'window { background-color: #171717; }'
        -theme-str 'inputbar { background-color: #2B2B2B; text-color: #ffffff; }'
        -theme-str 'entry { background-color: transparent; text-color: #ffffff; }'
        -theme-str 'element normal.normal { background-color: #2B2B2B; text-color: #ffffff; }'
        -theme-str 'element alternate.normal { background-color: #2B2B2B; text-color: #ffffff; }'
        -theme-str 'element selected.normal { background-color: #ffffff; text-color: #171717; }'
        -theme-str 'element-text { font: "Sans Bold 10"; }'
      )
      rofi_source=(
        "''${rofi_base[@]}"
        -theme-str 'window { border-color: #4A90D9; }'
        -theme-str 'prompt { text-color: #4A90D9; }'
      )
      rofi_target=(
        "''${rofi_base[@]}"
        -theme-str 'window { border-color: #D9870A; }'
        -theme-str 'prompt { text-color: #D9870A; }'
      )

      ACTIVE_LABELS=$(${realHyprctl} -j monitors | $py -c "
      import json, sys
      for m in json.load(sys.stdin):
          n, w, h = m['name'], m['width'], m['height']
          r = round(m['refreshRate'])
          print(f'{n}  {w}x{h} @ {r} Hz')
      ")

      # Build restore section from our own state file (hyprctl mirrorOf is unreliable after keyword)
      RESTORE_SECTION=""
      if [ -f "$state" ]; then
        while IFS=' ' read -r mon src; do
          [ -n "$mon" ] && RESTORE_SECTION+="↩  ''${mon}  (un-mirror from ''${src})"$'\n'
        done < "$state"
      fi

      if [ -n "$RESTORE_SECTION" ]; then
        MENU=$(printf '%s%s\n%s' "$RESTORE_SECTION" "$sep" "$ACTIVE_LABELS")
      else
        MENU=$ACTIVE_LABELS
      fi

      SOURCE_LABEL=$(printf '%s\n' "$MENU" | $rofi -dmenu -i -p "Mirror source" "''${rofi_source[@]}")
      [ -z "$SOURCE_LABEL" ] && exit 0
      [[ "''${SOURCE_LABEL}" == ────* ]] && exit 0

      # Un-mirror: restore saved position from conf, remove from state file
      if [[ "''${SOURCE_LABEL}" == "↩"* ]]; then
        MON=$(printf '%s\n' "''${SOURCE_LABEL}" | sed 's/^↩  \([^ ]*\).*/\1/')
        SAVED=$(grep "^monitor=''${MON}," "$conf" 2>/dev/null | grep -v ',mirror' | head -1 | sed 's/^monitor=//')
        if [ -n "$SAVED" ]; then
          ${realHyprctl} keyword monitor "''${SAVED}"
        else
          ${realHyprctl} keyword monitor "''${MON},preferred,auto,1"
        fi
        sed -i "/^''${MON} /d" "$state"
        $notify -t 3000 "Display" "''${MON} restored to extended mode"
        exit 0
      fi

      SOURCE=$(printf '%s\n' "$SOURCE_LABEL" | awk '{print $1}')

      TARGET_LABEL=$(printf '%s\n' "$ACTIVE_LABELS" | grep -v "^''${SOURCE}  " | \
        $rofi -dmenu -i -p "Mirror '$SOURCE' onto" "''${rofi_target[@]}")
      [ -z "$TARGET_LABEL" ] && exit 0
      TARGET=$(printf '%s\n' "$TARGET_LABEL" | awk '{print $1}')

      # Save current layout to conf (without mirror, for restore), record state
      ${realHyprctl} -j monitors | $py -c "
      import json, sys
      for m in json.load(sys.stdin):
          n, w, h = m['name'], m['width'], m['height']
          r, x, y, s = m['refreshRate'], m['x'], m['y'], m['scale']
          print(f'monitor={n},{w}x{h}@{r},{x}x{y},{s}')
      " > "$conf"
      echo "''${TARGET} ''${SOURCE}" >> "$state"

      ${realHyprctl} keyword monitor "''${TARGET},preferred,0x0,1,mirror,''${SOURCE}"
      $notify -t 3000 "Display" "''${SOURCE} → ''${TARGET} (mirrored)"
    '';
  in {
    home.packages = [
      pkgs.wdisplays
      pkgs.wlr-randr
      saveMonitors
      mirrorToggle
    ];
  };
}
