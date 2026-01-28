{ pkgs, ... }:
let 
  cliphistRofi = pkgs.writeShellScriptBin "cliphist-rofi" ''
    #!/usr/bin/env bash
    tmp_dir="/tmp/cliphist-thumbs"
    mkdir -p "$tmp_dir"

    # Feed cliphist content to Rofi with icons
    cliphist list | while read -r line; do
        id=$(echo "$line" | cut -d ' ' -f 1)
        
        if [[ "$line" == *"[Binary data"* ]]; then
            # Extract image for preview
            img="$tmp_dir/$id.png"
            if [ ! -f "$img" ]; then
                cliphist decode "$id" > "$img"
            fi
            echo -en "$line\0icon\x1f$img\n"
        else
            echo "$line"
        fi
    done | rofi -dmenu -show-icons -p "Clipboard" -display-columns 2 | cliphist decode | wl-copy
  '';
in
{
  home.packages = [ cliphistRofi ];

  # Configure the Service
  services.cliphist = {
    enable = true;
    allowImages = true; 
  };
}