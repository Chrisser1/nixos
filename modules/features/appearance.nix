{ self, ... }: {
  flake.homeModules.feature-appearance = { pkgs, ... }: {
    
    # MIME App Defaults
    xdg.mimeApps.defaultApplications."x-scheme-handler/jetbrains" = "jetbrains-toolbox.desktop";

    # Enforce Dark Mode in GNOME/dconf
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    # Enforce Dark Mode for GTK Apps
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      
      gtk4 = {
        extraConfig.gtk-application-prefer-dark-theme = 1;
        theme = null;
      };
    };

    # Enforce Dark Mode for QT Apps
    qt = {
      enable = true;
      platformTheme.name = "adwaita"; 
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
    
  };
}