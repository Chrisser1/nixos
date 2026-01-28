{ pkgs, ... }:
let 
  # THE SCRIPT
  berserk-clipboard = pkgs.writeShellScriptBin "berserk-clipboard" ''
    #!/usr/bin/env bash
    
    # Constants
    TMP_DIR="/tmp/cliphist-thumbs"
    mkdir -p "$TMP_DIR"
    
    # Read History
    mapfile -t lines < <(cliphist list)

    if [ ''${#lines[@]} -eq 0 ]; then
        notify-send "Clipboard" "History is empty."
        exit 0
    fi

    # Stream to Rofi
    selected_index=$(
        count=1
        for line in "''${lines[@]}"; do
            # Split ID and Content
            id=$(echo "$line" | cut -f1)
            content=$(echo "$line" | cut -f2-)
            
            # --- IMAGE HANDLING ---
            # Using your fixed lowercase check
            if [[ "$content" == *"binary data"* ]]; then
                img="$TMP_DIR/''${id}_large.png"
                
                if [ ! -f "$img" ]; then
                    cliphist decode "$id" | \
                    ${pkgs.imagemagick}/bin/magick - "$img"
                fi
                
                if [ -f "$img" ]; then
                    echo -en "$count.  Screenshot\x00icon\x1f$img\n"
                else
                    echo -en "$count.  Screenshot (No Preview)\n"
                fi
                
            else
                # --- TEXT HANDLING ---
                safe_content=$(echo "$content" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
                echo -en "$count. $safe_content\n"
            fi
            
            ((count++))
        done | rofi -dmenu -show-icons -markup-rows -p "Clipboard" -format i \
             -theme-str 'element-icon { size: 64px; }' \
             -theme-str 'listview { lines: 8; }'
    )

    # Exit if cancelled
    if [ -z "$selected_index" ]; then
        exit 0
    fi

    # Paste Logic
    target_line="''${lines[$selected_index]}"
    target_id=$(echo "$target_line" | cut -f1)

    cliphist decode "$target_id" | wl-copy

    sleep 0.2
    wtype -M ctrl -k v -m ctrl
  '';
in
{
  home.packages = with pkgs; [
    berserk-clipboard
    wtype
    wl-clipboard
    imagemagick  
  ];

  services.cliphist = {
    enable = true;
    allowImages = true; 
    extraOptions = [ "-max-items" "500" ];
  };
}