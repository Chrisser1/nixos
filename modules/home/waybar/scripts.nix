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

in {
  inherit checkBattery;

  # --- UPDATED WALLPAPER PICKER ---
  wallpaperPicker = pkgs.writeShellScriptBin "wallpaper-picker" ''
    #!/usr/bin/env bash
    set -euo pipefail

    BASE_DIR="$HOME/.config/backgrounds"
    TARGET_DIR="$HOME/.local/state/wpaperd/selected"

    # Ensure we have themes
    if [ -z "$(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d)" ]; then
      notify-send "Error" "No theme folders found in $BASE_DIR"
      exit 1
    fi

    # 1. Select Theme
    THEME=$(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%P\n' | sort | wofi --dmenu -p "Select Theme")
    [[ -z "$THEME" ]] && exit 0

    # 2. Select Wallpaper
    SELECTION=$(ls -1 "$BASE_DIR/$THEME" | wofi --dmenu -p "Select Wallpaper")
    [[ -z "$SELECTION" ]] && exit 0

    # 3. Setup the target directory
    mkdir -p "$TARGET_DIR"
    rm -f "$TARGET_DIR"/*

    # 4. Link the new wallpaper (PRESERVING EXTENSION)
    FULL_PATH="$BASE_DIR/$THEME/$SELECTION"
    
    # Extract extension (e.g., "jpg")
    EXT="''${SELECTION##*.}"
    
    # Link as wallpaper.jpg (or .png, etc.) so wpaperd recognizes it
    ln -sf "$FULL_PATH" "$TARGET_DIR/wallpaper.$EXT"

    # 5. Restart the service to apply changes
    systemctl --user restart wpaperd.service
    
    notify-send "Wallpaper" "Changed to $THEME/$SELECTION"
  '';

  # --- UPDATED LABEL SCRIPT ---
  wallpaperLabel = pkgs.writeShellScriptBin "waybar-wallpaper-label" ''
    #!/usr/bin/env bash
    TARGET_DIR="$HOME/.local/state/wpaperd/selected"
    
    # Find the file inside the directory (should be only one, e.g. wallpaper.jpg)
    FILE=$(ls -1 "$TARGET_DIR" 2>/dev/null | head -n 1)
    
    if [[ -n "$FILE" ]]; then
      # Resolve the symlink to get the real name (e.g. "Farm.jpg")
      REAL_PATH=$(readlink -f "$TARGET_DIR/$FILE")
      FILENAME=$(basename "$REAL_PATH")
      # Strip extension to show just "Farm"
      echo "''${FILENAME%.*}"
    else
      echo "?"
    fi
  '';

  # Audio Sink Menu (Unchanged)
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