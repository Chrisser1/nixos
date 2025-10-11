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

  # Portals for Wayland apps (Hyprland + GTK)
  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
