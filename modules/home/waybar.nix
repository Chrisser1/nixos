{ 
  config, 
  pkgs, 
  ... 
}:
let
  # helper scripts (all end up on PATH)
  wpctlSinkMenu = pkgs.writeShellScriptBin "wpctl-sink-menu" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Read only the Sinks block (don't anchor to column 0)
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


  # show current wpaperd wallpaper (take first display’s symlink)
  wallpaperLabel = pkgs.writeShellScriptBin "waybar-wallpaper-label" ''
    #!/usr/bin/env bash
    link="$(ls -1 ~/.local/state/wpaperd/wallpapers 2>/dev/null | head -n1)"
    [[ -z "$link" ]] && exit 0
    real="$(readlink -f "$HOME/.local/state/wpaperd/wallpapers/$link" 2>/dev/null)"
    [[ -n "$real" ]] && basename "$real"
  '';
in {
  # Deps you reference in on-click handlers
  home.packages = with pkgs; [
    playerctl wofi jq pavucontrol libnotify
    wpctlSinkMenu wallpaperLabel
  ];

  programs.waybar = {
    enable = true;

    # JSON rendered from attrsets
    settings.mainBar = {
      position = "top";
      "modules-left"   = [ "hyprland/workspaces" "mpris" ];
      "modules-center" = [ "hyprland/window" ];
      "modules-right"  = [
        "custom/wallpaper"
        "network#eth"
        "network#wifi"
        "memory"
        "cpu"
        "pulseaudio"
        "battery"
        "clock"
      ];

      "hyprland/window" = {
        "swap-icon-label" = false;
      };

      clock = {
        format = "<span foreground='#f5c2e7'>   </span>{:%a %d %H:%M}";
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      battery = {
        states = { warning = 30; critical = 15; };
        format           = "<span size='13000' foreground='#a6e3a1'>{icon} </span> {capacity}%";
        "format-warning" = "<span size='13000' foreground='#B1E3AD'>{icon} </span> {capacity}%";
        "format-critical"= "<span size='13000' foreground='#E38C8F'>{icon} </span> {capacity}%";
        "format-charging"= "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
        "format-plugged" = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
        "format-alt"     = "<span size='13000' foreground='#B1E3AD'>{icon} </span> {time}";
        "format-full"    = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
        "format-icons"   = [ "" "" "" "" "" ];
        "tooltip-format" = "{time}";
      };

      # Ethernet instance
      "network#eth" = {
        interface = "en*";
        "format-ethernet"       = "<span size='13000'>󰈀 {bandwidthDownOctets} ↓ {bandwidthUpOctets} ↑</span>";
        "format-disconnected"   = "";
        "tooltip-format-ethernet" = "Download: {bandwidthDownBits}\nUpload: {bandwidthUpBits}";
        interval = 1; "max-length" = 40;
      };

      # Wi-Fi instance
      "network#wifi" = {
        interface = "wl*";
        "format-wifi"         = "<span size='13000' foreground='#f5e0dc'> </span>{essid} ({signalStrength}%)";
        "format-disconnected" = "";
        "tooltip-format-wifi" = "Signal Strength: {signalStrength}%";
      };

      # Built-in MPRIS (replaces the custom Spotify JSON tail)
      mpris = {
        player = "spotify";          # or drop this to follow the active player
        interval = 1;                # <— makes position tick
        dynamic-order = [ "title" "artist" "position" "length" ];
      
        # Keep your clicks
        "on-click" = "playerctl play-pause -p spotify";
        "on-scroll-up" = "playerctl next -p spotify";
        "on-scroll-down" = "playerctl previous -p spotify";
      
        # Optional: icons (lets CSS do the coloring)
        "format" = "{player_icon} {dynamic}";
        "format-paused" = "{player_icon} {dynamic}";
        "player-icons".default = "";
        "status-icons".paused = "";
      };


      pulseaudio = {
        format = "{icon}  {volume}%";
        "format-muted" = "";
        "format-icons".default = [ "" "" "" ];
        "on-click" = "wpctl-sink-menu";
      };

      # Wallpaper widget, talks to wpaperd
      "custom/wallpaper" = {
        exec = "waybar-wallpaper-label";
        "return-type" = "text";
        interval = 1;
        format = "<span size='13000' foreground='#cba6f7'>  </span>{}";
        "on-scroll-up" = "wpaperctl next-wallpaper";
        "on-scroll-down" = "wpaperctl previous-wallpaper";
        # click could open your picker; with wpaperd there's no direct “set file”
        # CLI yet, so we stick to next/prev for now.
      };

      cpu = {
        interval = 5;
        format = "  CPU: {usage}%";
        "tooltip-format" = "Load: {load}  Avg Freq: {avg_frequency} GHz";
      };

      memory = {
        interval = 10;
        format = "RAM: ({used:0.1f}/{total:0.1f}) GiB";
        "tooltip-format" = "{percentage}% used";
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        "show-empty-workspaces" = false;
        "format-icons" = {
          "1"="1"; "2"="2"; "3"="3"; "4"="4"; "5"="5";
          "6"="6"; "7"="7"; "8"="8"; "9"="9"; "10"="0";
          "11"="1"; "12"="2"; "13"="3"; "14"="4"; "15"="5";
          "16"="6"; "17"="7"; "18"="8"; "19"="9"; "20"="0";
          active=""; visible=""; urgent=""; empty="";
        };
      };
    };
  };

  # Install your CSS pieces as files Waybar can @import
  home.file.".config/waybar/mocha.css".text  = builtins.readFile ../../assets/waybar/mocha.css;
  home.file.".config/waybar/style.css".text  = builtins.readFile ../../assets/waybar/style.css;
}
