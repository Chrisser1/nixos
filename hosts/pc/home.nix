{
  config,
  pkgs,
  inputs,
  ...
}: 
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-4,preferred,auto,1.25"

      "HDMI-A-2,preferred,auto-left,1"
    ];
  };
}