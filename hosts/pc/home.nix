{
  config,
  pkgs,
  inputs,
  ...
}: 
{ 
  wayland.windowManager.hyprland.settings.monitor = [
    "DP-4,preferred,auto,1.4"
    "HDMI-A-1,preferred,auto,0.8"
  ];
}
