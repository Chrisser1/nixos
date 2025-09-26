{
  config,
  pkgs,
  inputs,
  ...
}: 
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-4,preferred,auto,1"

      "HDMI-A-2,preferred,auto-left,1"
    ];

    # (Recommended) Ensure workspace 1 always lives on your main DP-4 monitor.
    workspace = "1, monitor:DP-4, default:true";
  };
}