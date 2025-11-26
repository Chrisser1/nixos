{ pkgs, scripts, ... }:

{
  # --- Groups ---
  
  "group/hardware" = {
    name = "hardware";
    orientation = "horizontal";
    modules = [
      "disk"
      "cpu"
      "memory"
      "custom/gpu"
    ];
  };

  "group/tools" = {
    name = "tools";
    orientation = "horizontal";
    modules = [
      "network#wifi"
      "network#eth"
      "pulseaudio"
      "battery"
      "custom/wallpaper"
    ];
  };

  # --- Hardware Modules ---

  disk = {
    interval = 30;
    format = " {percentage_used}%";
    path = "/";
    "on-click" = "kitty -e btop"; # 
  };

  cpu = {
    interval = 5;
    format = " {usage}%";
    "on-click" = "kitty -e btop"; # 
  };

  memory = {
    interval = 10;
    format = " {percentage}%";
    "on-click" = "kitty -e btop"; # 
  };

  "custom/gpu" = {
    exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
    format = " {}%";
    interval = 5;
    "on-click" = "kitty -e btop";
  };

  # --- Tools Modules ---

  pulseaudio = {
    format = "{icon} {volume}%";
    "format-muted" = "";
    "format-icons" = { default = [ "" "" "" ]; };
    "on-click" = "${scripts.wpctlSinkMenu}/bin/wpctl-sink-menu";
  };

  "network#wifi" = {
    interface = "wl*";
    format = "{icon}";
    "format-wifi" = "  {signalStrength}%";
    "format-disconnected" = " ";
    "tooltip-format" = "{essid}";
    "on-click" = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
  };

  "network#eth" = {
    interface = "en*";
    format = "󰈀";
    "format-disconnected" = "";
    "tooltip-format" = "{ifname}";
  };

  battery = {
    states = { warning = 30; critical = 15; };
    format = "{icon} {capacity}%";
    "format-charging" = " {capacity}%";
    "format-icons" = [ "" "" "" "" "" ];
  };

  "custom/wallpaper" = {
    exec = "${scripts.wallpaperLabel}/bin/waybar-wallpaper-label";
    "return-type" = "text";
    interval = 2;
    format = "  {}";
    # Opens the popup menu
    "on-click" = "${scripts.wallpaperPicker}/bin/wallpaper-picker"; 
  };

  # --- Media ---
  mpris = {
    player = "spotify";
    # Added position and length here
    format = "  {artist} - {title} <span color='#a6adc8'>({position}/{length})</span>";
    "format-paused" = "  {artist} - {title} <span color='#a6adc8'>({position}/{length})</span>";
    
    "max-length" = 60;
    interval = 1;
    
    # --- CONTROLS ---
    "on-click" = "playerctl play-pause -p spotify";
    "on-click-right" = "playerctl next -p spotify";
    "on-click-middle" = "playerctl previous -p spotify";
    
    "on-scroll-up" = "playerctl next -p spotify";
    "on-scroll-down" = "playerctl previous -p spotify";
  };
  
  # --- Other ---

  "hyprland/workspaces" = {
    format = "{icon}";
    "on-click" = "activate";
    "format-icons" = {
      "1"="1"; "2"="2"; "3"="3"; "4"="4"; "5"="5";
      "6"="6"; "7"="7"; "8"="8"; "9"="9"; "10"="0";
      urgent=""; active=""; default=""; empty="";
    };
    "persistent-workspaces" = {
        "*" = 5;
    };
  };

  clock = {
    format = "  {:%H:%M}";
    "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    "format-alt" = "  {:%d/%m/%Y}";
  };
  
  "custom/power" = {
    format = "⏻";
    "on-click" = "powermenu"; 
    tooltip = false;
  };
}