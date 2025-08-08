{ 
    pkgs, 
    inputs, 
    lib,
    ... 
}:
{
  # Session + compositor (shared across hosts)
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    defaultSession = "hyprland";
  };

  # Portals for Wayland apps (Hyprland + GTK)
  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Helpful for Electron/Chromium apps on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
