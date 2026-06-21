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
      theme="$HOME/.config/rofi/noctalia.rasi"

      # Read accent colors from noctalia palette; fall back to safe defaults
      _nc="$HOME/.config/noctalia/colors.json"
      _get() { awk -F'"' -v k="$1" '$2==k{gsub("#","",$(NF-1));print $(NF-1)}' "$_nc" 2>/dev/null; }
      if [ -f "$_nc" ]; then
        c_pri=$(_get mPrimary);    c_on_pri=$(_get mOnPrimary)
        c_sec=$(_get mSecondary);  c_on_sec=$(_get mOnSecondary)
      fi
      c_pri=''${c_pri:-39bae6};   c_on_pri=''${c_on_pri:-0b0e14}
      c_sec=''${c_sec:-aad94c};   c_on_sec=''${c_on_sec:-0b0e14}

      # Step-specific overrides on top of the noctalia rofi base theme
      _rofi() {
        local accent="$1" on_accent="$2" mesg="$3" prompt="$4"
        $rofi -dmenu -i \
          -theme "$theme" \
          -theme-str "window { border: 2px; border-color: #''${accent}; border-radius: 10px; width: 520px; }" \
          -theme-str "element selected { background-color: #''${accent}; text-color: #''${on_accent}; }" \
          -theme-str "prompt { text-color: #''${accent}; }" \
          -mesg "$mesg" \
          -p "$prompt"
      }

      # Format monitor list with resolution and refresh rate
      _monitors() {
        ${realHyprctl} -j monitors | $py -c "
      import json, sys
      for m in json.load(sys.stdin):
          n, w, h = m['name'], m['width'], m['height']
          r = round(m['refreshRate'])
          desc = m.get('description', '''').split('(')[0].strip()
          label = f'  {desc}' if desc else ''''
          print(f'  {n}   {w}×{h} @ {r}Hz{label}')
      "
      }

      # Build menu: restore entries on top, then active monitors
      MONITORS=$(_monitors)
      RESTORE=""
      if [ -f "$state" ]; then
        while IFS=' ' read -r mon src; do
          [ -n "$mon" ] && RESTORE+="  ''${mon}   unmirroring from ''${src}"$'\n'
        done < "$state"
      fi

      if [ -n "$RESTORE" ]; then
        MENU=$(printf '%s\n%s' "''${RESTORE%$'\n'}" "$MONITORS")
      else
        MENU=$MONITORS
      fi

      # Step 1: pick source (or un-mirror)
      SOURCE_LINE=$(printf '%s\n' "$MENU" | \
        _rofi "$c_pri" "$c_on_pri" "Pick a monitor to mirror — or select an active mirror to undo it" " Source")
      [ -z "$SOURCE_LINE" ] && exit 0

      # Handle un-mirror
      if [[ "$SOURCE_LINE" == *"unmirroring"* ]]; then
        MON=$(printf '%s' "$SOURCE_LINE" | awk '{print $2}')
        SAVED=$(grep "^monitor=''${MON}," "$conf" 2>/dev/null | grep -v ',mirror' | head -1 | sed 's/^monitor=//')
        if [ -n "$SAVED" ]; then
          ${realHyprctl} keyword monitor "''${SAVED}"
        else
          ${realHyprctl} keyword monitor "''${MON},preferred,auto,1"
        fi
        sed -i "/^''${MON} /d" "$state"
        $notify -u low -t 3000 "Display" "''${MON} restored to extended mode"
        exit 0
      fi

      SOURCE=$(printf '%s' "$SOURCE_LINE" | awk '{print $2}')

      # Step 2: pick target
      TARGET_LINE=$(_monitors | grep -v "  ''${SOURCE} " | \
        _rofi "$c_sec" "$c_on_sec" "Mirror  ''${SOURCE}  onto which monitor?" " Target")
      [ -z "$TARGET_LINE" ] && exit 0
      TARGET=$(printf '%s' "$TARGET_LINE" | awk '{print $2}')

      # Save current layout for restore, then apply mirror
      ${realHyprctl} -j monitors | $py -c "
      import json, sys
      for m in json.load(sys.stdin):
          n, w, h = m['name'], m['width'], m['height']
          r, x, y, s = m['refreshRate'], m['x'], m['y'], m['scale']
          print(f'monitor={n},{w}x{h}@{r},{x}x{y},{s}')
      " > "$conf"
      echo "''${TARGET} ''${SOURCE}" >> "$state"

      ${realHyprctl} keyword monitor "''${TARGET},preferred,0x0,1,mirror,''${SOURCE}"
      $notify -u low -t 3000 "Display" "''${SOURCE}  →  ''${TARGET}  (mirrored)"
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
