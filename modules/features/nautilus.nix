{ self, ... }: {
  flake.homeModules.feature-nautilus = { pkgs, ... }: {
    home.packages = with pkgs; [
      nautilus
      gvfs
      ffmpegthumbnailer  
      webp-pixbuf-loader 
      libheif            
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "application/pdf" = [ "org.kde.okular.desktop" ];
      };
    };
  };
}