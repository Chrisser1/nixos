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
    xdg.mimeApps.defaultApplications."x-scheme-handler/jetbrains" = "jetbrains-toolbox.desktop";

    home = {
      stateVersion = "25.05";
      enableNixpkgsReleaseCheck = false;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "Adwaita-dark";
      style = {
        name = "Adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };
}