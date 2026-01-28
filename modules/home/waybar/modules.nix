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
      "network"
      "pulseaudio"
      "battery"
      "custom/watts"
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

  network = {
    format = "{ifname}";
    "format-wifi" = "  {signalStrength}%";
    "format-ethernet" = "󰈀  ⬇{bandwidthDownBytes} ⬆{bandwidthUpBytes}";
    "format-disconnected" = "󰤭  Disconnected"; 

    "tooltip-format" = "{ifname} via {gwaddr}";
    "tooltip-format-wifi" = "{essid} ({signalStrength}%)";
    "tooltip-format-ethernet" = "{ifname} ";
    "tooltip-format-disconnected" = "Disconnected";
    "max-length" = 50;
    "on-click" = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
  };

  pulseaudio = {
    format = "{icon} {volume}%";
    "format-muted" = "";
    "format-icons" = { default = [ "" "" "" ]; };
    "on-click" = "${scripts.wpctlSinkMenu}/bin/wpctl-sink-menu";
  };

  battery = {
    states = { warning = 30; critical = 15; };
    format = "{icon} {capacity}%";
    "format-charging" = " {capacity}%";
    "format-icons" = [ "" "" "" "" "" ];
  };

  "custom/watts" = {
    exec = "${scripts.getWatts}/bin/get-watts";
    interval = 5;
  };

  "custom/wallpaper" = {
    exec = "${scripts.wallpaperLabel}/bin/waybar-wallpaper-label";
    "return-type" = "text";
    interval = 2;
    format = "  {}";
    # Opens the popup menu
    "on-click" = "${scripts.wallpaperPicker}/bin/wallpaper-picker"; 
  };

  # --- Workspaces ---
  "hyprland/workspaces" = {
    format = "{icon}";
    "on-click" = "activate";
    "all-outputs" = false;
    
    "format-icons" = {
      "1"="1"; "2"="2"; "3"="3"; "4"="4"; "5"="5";
      "6"="6"; "7"="7"; "8"="8"; "9"="9"; "10"="0";
      "11"="1"; "12"="2"; "13"="3"; "14"="4"; "15"="5";
      "16"="6"; "17"="7"; "18"="8"; "19"="9"; "20"="0";
      "21"="1"; "22"="2"; "23"="3"; "24"="4"; "25"="5";
      "26"="6"; "27"="7"; "28"="8"; "29"="9"; "30"="0";
      "31"="1"; "32"="2"; "33"="3"; "34"="4"; "35"="5";
      "36"="6"; "37"="7"; "38"="8"; "39"="9"; "40"="0";
      urgent=""; active=""; default=""; empty="";
    };
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