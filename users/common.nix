{ 
    pkgs, 
    inputs, 
    lib, 
    config,
    ... 
}:
{
  # Pull in your shared HM stack
  imports = [
    ../modules/home
    
    # Terminal
    ../modules/home/terminal/fish.nix
    ../modules/home/terminal/bash.nix
  ];
 
  options.my.shell = lib.mkOption {
    type = lib.types.enum [ "fish" "bash" ];
    default = "fish"; # Sets a safe default
    description = "The default shell for the user.";
  };

  config = {
    nixpkgs.config.allowUnfree = true;
    xdg.mimeApps.defaultApplications."inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    xdg.mimeApps.defaultApplications."x-scheme-handler/jetbrains" = "jetbrains-toolbox.desktop";

    home = {
      stateVersion = "25.05";
    };

    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}