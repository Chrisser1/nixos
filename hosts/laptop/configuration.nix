{
  config,
  pkgs,
  inputs,
  ...
}: {
  networking.hostName = "laptop";
  system.stateVersion = "25.05";
  imports = [
    ./hardware-configuration.nix
  ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true; # Required for Wayland sessions
    };
    defaultSession = "hyprland";
  };

  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;
  environment.variables = {
    USE_WAYLAND_GRIM = 1;
  };

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
