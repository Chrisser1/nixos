{
  config,
  pkgs,
  inputs,
  ...
}: 
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      # ASUS primary on the left at 0,0, scale 1
      "HDMI-A-1,preferred,auto-left,1"

      # Secondary to the right; replace 1920 with ASUS's native width
      "DP-4,preferred,auto,1"
    ];

    # (optional) ensure workspace 1 lives on the ASUS
    workspace = [
      "1, monitor:DP-4, default:true"
    ];
  };
}