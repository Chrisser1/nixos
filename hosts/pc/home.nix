{
  config,
  pkgs,
  inputs,
  ...
}: 
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-4,preferred,0x0,1"
      "HDMI-A-2,preferred,auto-left,0.8"
    ];

    # # (optional) ensure workspace 1 lives on the ASUS
    # workspace = [
    #   "1, monitor:HDMI-A-2, default:true"
    # ];
  };

  wayland.clion = {
    enable = true;
    scale = 1;
  };
}