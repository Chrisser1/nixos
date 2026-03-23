{ self, ... }: {
  flake.homeModules.pc-home = { config, pkgs, inputs, ... }: {
    home.stateVersion = "25.05";
    
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "DP-4,preferred,auto,1"
        "HDMI-A-2,preferred,auto-left,1"
      ];
    };
  };
}