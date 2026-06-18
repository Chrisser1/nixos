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
      sep="────────────────────────"

      # One pass: "NAME\tNAME  WxH @ RHz" per active monitor
      MONITOR_INFO=$(${realHyprctl} -j monitors | $py -c "
      import json, sys
      for m in json.load(sys.stdin):
          n, w, h = m['name'], m['width'], m['height']
          r = round(m['refreshRate'])
          print(f'{n}\t{n}  {w}×{h} @ {r} Hz')
      ")

      ACTIVE_NAMES=$(printf '%s\n' "$MONITOR_INFO" | cut -f1)
      ACTIVE_LABELS=$(printf '%s\n' "$MONITOR_INFO" | cut -f2)

      # Monitors saved in conf but absent from hyprctl are currently mirrored (hidden)
      RESTORE_SECTION=""
      if [ -f "$conf" ]; then
        while IFS= read -r name; do
          printf '%s\n' "$ACTIVE_NAMES" | grep -qxF "$name" || \
            RESTORE_SECTION+="↩  ''${name}  (restore)"$'\n'
        done < <(grep '^monitor=' "$conf" | grep -v ',disable' | sed 's/monitor=\([^,]*\).*/\1/')
      fi

      if [ -n "$RESTORE_SECTION" ]; then
        MENU=$(printf '%s%s\n%s' "$RESTORE_SECTION" "$sep" "$ACTIVE_LABELS")
      else
        MENU=$ACTIVE_LABELS
      fi

      SOURCE_LABEL=$(printf '%s\n' "$MENU" | $rofi -dmenu -i -p "Mirror source")
      [ -z "$SOURCE_LABEL" ] && exit 0
      [[ "''${SOURCE_LABEL}" == ────* ]] && exit 0

      # Restore a previously mirrored monitor
      if [[ "''${SOURCE_LABEL}" == "↩"* ]]; then
        MON=$(printf '%s\n' "''${SOURCE_LABEL}" | sed 's/^↩  \([^ ]*\).*/\1/')
        ${realHyprctl} keyword monitor "''${MON},preferred,auto,1"
        $notify -t 3000 "Display" "''${MON} restored to extended mode"
        exit 0
      fi

      SOURCE=$(printf '%s\n' "$SOURCE_LABEL" | awk '{print $1}')

      TARGET_LABEL=$(printf '%s\n' "$ACTIVE_LABELS" | grep -v "^''${SOURCE}  " | \
        $rofi -dmenu -i -p "Mirror '$SOURCE' onto")
      [ -z "$TARGET_LABEL" ] && exit 0
      TARGET=$(printf '%s\n' "$TARGET_LABEL" | awk '{print $1}')

      # Save current layout before mirroring so restore can recover it
      ${realHyprctl} -j monitors | $py -c "
      import json, sys
      for m in json.load(sys.stdin):
          n, w, h = m['name'], m['width'], m['height']
          r, x, y, s = m['refreshRate'], m['x'], m['y'], m['scale']
          print(f'monitor={n},{w}x{h}@{r},{x}x{y},{s}')
      " > "$conf"

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
