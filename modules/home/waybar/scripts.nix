{ pkgs }:

let
  checkBattery = pkgs.writeShellScript "check-battery" ''
    have_bat=0
    for t in /sys/class/power_supply/*/type; do
      [ -r "$t" ] || continue
      if echo "$t" | grep -q "hidpp_battery"; then continue; fi
      if grep -qx "Battery" "$t"; then
        have_bat=1
        break
      fi
    done
    if [ "$have_bat" -eq 1 ]; then printf '|'; fi
  '';

  getWatts = pkgs.writeShellScriptBin "get-watts" ''
    #!/usr/bin/env bash
    if /usr/bin/env find /sys/class/power_supply/ -name "BAT*" | grep -q .; then exit 0; fi
    for p in /sys/class/hwmon/hwmon*/power*_input; do
      [ -f "$p" ] || continue
      VAL=$(cat "$p")
      W=$(echo "scale=1; $VAL / 1000000" | bc)
      if (( $(echo "$W > 0" | bc -l) )); then
        echo " $W W"
        exit 0
      fi
    done
  '';
in {
  inherit checkBattery;
  inherit getWatts;
  
  launchWaybar = pkgs.writeShellScriptBin "launch-waybar" ''
    #!/usr/bin/env bash
  
    BASE_CONFIG="$HOME/.config/waybar/config"
    TEMP_CONFIG="$HOME/.cache/waybar-dynamic-config"
    
    if ! command -v jq &> /dev/null || ! command -v hyprctl &> /dev/null; then
        waybar &
        exit 1
    fi

    MONITORS=$(hyprctl monitors -j | jq -r 'sort_by(.id) | .[].name')

    # --- CHANGED HERE: Removed "mainBar" wrapper ---
    # We now start directly with the module definition so it merges at the root level
    PATCH="{ \"hyprland/workspaces\": { \"persistent-workspaces\": { "
    
    INDEX=0
    FIRST_MON=true
    
    for MON in $MONITORS; do
      if [ "$FIRST_MON" = true ]; then FIRST_MON=false; else PATCH="$PATCH, "; fi
      
      START=$((INDEX * 10 + 1))
      
      PATCH="$PATCH \"$MON\": ["
      for i in $(seq 0 4); do
        WS=$((START + i))
        if [ "$i" -gt 0 ]; then PATCH="$PATCH, "; fi
        PATCH="$PATCH $WS"
      done
      PATCH="$PATCH]"
      INDEX=$((INDEX + 1))
    done
    
    PATCH="$PATCH } } }"

    mkdir -p "$(dirname "$TEMP_CONFIG")"

    # Merge logic: If base is array, unwrap it, merge patch, then (implicitly) use that object
    if jq -s 'if (.[0] | type) == "array" then (.[0][0] * .[1]) else (.[0] * .[1]) end' "$BASE_CONFIG" <(echo "$PATCH") > "$TEMP_CONFIG"; then
        waybar -c "$TEMP_CONFIG" & disown
    else
        waybar &
    fi
  '';

  # ... (Keep wallpaperPicker, wallpaperLabel, wpctlSinkMenu same as before) ...
  wallpaperPicker = pkgs.writeShellScriptBin "wallpaper-picker" ''
    #!/usr/bin/env bash
    set -euo pipefail
    BASE_DIR="$HOME/.config/backgrounds"
    TARGET_DIR="$HOME/.local/state/wpaperd/selected"
    
    if [ -z "$(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d)" ]; then
      notify-send "Error" "No theme folders found in $BASE_DIR"
      exit 1
    fi
    THEME=$(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%P\n' | sort | wofi --dmenu -p "Select Theme")
    [[ -z "$THEME" ]] && exit 0
    SELECTION=$(ls -1 "$BASE_DIR/$THEME" | wofi --dmenu -p "Select Wallpaper")
    [[ -z "$SELECTION" ]] && exit 0
    
    mkdir -p "$TARGET_DIR"
    rm -f "$TARGET_DIR"/*
    FULL_PATH="$BASE_DIR/$THEME/$SELECTION"
    EXT="''${SELECTION##*.}"
    ln -sf "$FULL_PATH" "$TARGET_DIR/wallpaper.$EXT"
    systemctl --user restart wpaperd.service
    notify-send "Wallpaper" "Changed to $THEME/$SELECTION"
  '';

  wallpaperLabel = pkgs.writeShellScriptBin "waybar-wallpaper-label" ''
    #!/usr/bin/env bash
    TARGET_DIR="$HOME/.local/state/wpaperd/selected"
    FILE=$(ls -1 "$TARGET_DIR" 2>/dev/null | head -n 1)
    if [[ -n "$FILE" ]]; then
      REAL_PATH=$(readlink -f "$TARGET_DIR/$FILE")
      FILENAME=$(basename "$REAL_PATH")
      echo "''${FILENAME%.*}"
    else
      echo "?"
    fi
  '';

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
}