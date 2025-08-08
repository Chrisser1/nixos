{
  config,
  pkgs,
  inputs,
  ...
}: 
{ 
  wayland.windowManager.hyprland.settings.monitor = [
    "HDMI-A-1,preferred,auto,1"
    "DP-1,preferred,auto-left,1"
    "DP-2,preferred,auto-right,1"
  ];
}
