{ 
    pkgs, 
    inputs, 
    lib, 
    ... 
}:
{
  nixpkgs.config.allowUnfree = true;
  xdg.mimeApps.defaultApplications."inode/directory" = [ "org.gnome.Nautilus.desktop" ];
  xdg.mimeApps.defaultApplications."x-scheme-handler/jetbrains" = "jetbrains-toolbox.desktop";

  home = {
    stateVersion = "25.05";
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  # Pull in your shared HM stack (kitty, starship, hyprland, waybar, etc.)
  imports = [
    ../modules/home
  ];
}