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
      enable = true;
      
      # Set a base Dark Theme
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        
        extraCss = ''
          /* Berserk Window Backgrounds */
          window, headerbar, .titlebar, dialog {
            background-color: #171717; /* bg2 */
            color: #EDE6DB;            /* text */
          }

          /* Content Backgrounds (lists, inputs) */
          view, list, row, entry, textview {
            background-color: #2B2B2B; /* bg0 */
            color: #EDE6DB;            /* text */
          }

          /* Borders and Highlights */
          button, entry {
            border: 1px solid #7F0909; /* red */
          }

          /* Selected Items */
          row:selected, list:selected, selection {
            background-color: #33ccffee; /* red */
            color: #FFFFFF;
          }

          /* Text Colors */
          label {
            color: #EDE6DB;
          }
        '';
      };

      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        extraCss = ''
          window, headerbar, .titlebar, dialog { background-color: #171717; color: #EDE6DB; }
          view, list, row, entry { background-color: #2B2B2B; color: #EDE6DB; }
          button, entry { border: 1px solid #33ccffee; }
          row:selected, list:selected, selection { background-color: #33ccffee; color: #FFFFFF; }
        '';
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