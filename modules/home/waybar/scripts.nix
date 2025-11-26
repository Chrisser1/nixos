{ pkgs }:
let
  # Script to check for battery
  checkBattery = pkgs.writeShellScript "check-battery" ''
    have_bat=0
    for t in /sys/class/power_supply/*/type; do
      [ -r "$t" ] || continue
      # Skip Logitech mice/keyboards
      if echo "$t" | grep -q "hidpp_battery"; then continue; fi
      # Check for actual battery
      if grep -qx "Battery" "$t"; then
        have_bat=1
        break
      fi
    done
    if [ "$have_bat" -eq 1 ]; then printf '|'; fi
  '';

in {
  inherit checkBattery;

  # Audio Sink Menu
  wpctlSinkMenu = pkgs.writeShellScriptBin "wpctl-sink-menu" ''
    #!/usr/bin/env bash
    set -euo pipefail
    mapfile -t SINKS < <(wpctl status | awk '
      /Sinks:/   {ins=1; next}
      /Sources:/ {ins=0}
      ins && match($0, /[[:space:]]\*?[[:space:]]*([0-9]+)\.\s+(.*)$/, m) {
        print m[1] "|" m[2]
      }
    ')
    if [[ ''${#SINKS[@]} -eq 0 ]]; then
      notify-send "Audio" "No sinks found"
      exit 1
    fi
    MENU=$(printf "%s\n" "''${SINKS[@]}" | cut -d"|" -f2)
    CHOICE=$(printf "%s\n" "$MENU" | wofi --dmenu -i -p "Switch output to:" --lines 10)
    [[ -z "$CHOICE" ]] && exit 0
    ID=$(printf "%s\n" "''${SINKS[@]}" | grep -F -m1 "|$CHOICE" | cut -d"|" -f1)
    wpctl set-default "$ID"
  '';

  # Wallpaper Label
  wallpaperLabel = pkgs.writeShellScriptBin "waybar-wallpaper-label" ''
    #!/usr/bin/env bash
    link="$(ls -1 ~/.local/state/wpaperd/wallpapers 2>/dev/null | head -n1)"
    [[ -z "$link" ]] && exit 0
    real="$(readlink -f "$HOME/.local/state/wpaperd/wallpapers/$link" 2>/dev/null)"
    [[ -n "$real" ]] && basename "$real"
  '';
}