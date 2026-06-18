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
      conf="$HOME/.config/hypr/monitors.conf"

      # Active monitors from hyprctl
      ACTIVE=$(${realHyprctl} -j monitors | $py -c "
      import json,sys
      print('\n'.join(m['name'] for m in json.load(sys.stdin)))
      ")

      # Monitors in monitors.conf that are not active are currently mirroring
      RESTORE_OPTS=""
      if [ -f "$conf" ]; then
        while IFS= read -r mon; do
          echo "$ACTIVE" | grep -qx "$mon" || RESTORE_OPTS+="Restore $mon"$'\n'
        done < <(grep '^monitor=' "$conf" | grep -v ',disable' | sed 's/monitor=\([^,]*\).*/\1/')
      fi

      MENU="''${RESTORE_OPTS}''${ACTIVE}"
      SOURCE=$(echo -n "$MENU" | $rofi -dmenu -p "Mirror which display?")
      [ -z "$SOURCE" ] && exit 0

      # Restore a mirrored display back to extended mode
      if [[ "$SOURCE" == "Restore "* ]]; then
        MON="''${SOURCE#Restore }"
        ${realHyprctl} keyword monitor "$MON,preferred,auto,1"
        exit 0
      fi

      # Pick which display will show the mirror
      TARGET=$(echo "$ACTIVE" | grep -v "^$SOURCE$" | $rofi -dmenu -p "Show '$SOURCE' on:")
      [ -z "$TARGET" ] && exit 0

      # Save current state before mirroring so Restore can find the hidden monitor later
      ${realHyprctl} -j monitors | ${pkgs.python3}/bin/python3 -c "
      import json, sys
      for m in json.load(sys.stdin):
          n = m['name']
          w, h = m['width'], m['height']
          r = m['refreshRate']
          x, y = m['x'], m['y']
          s = m['scale']
          print(f'monitor={n},{w}x{h}@{r},{x}x{y},{s}')
      " > "$conf"

      ${realHyprctl} keyword monitor "$TARGET,preferred,0x0,1,mirror,$SOURCE"
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
