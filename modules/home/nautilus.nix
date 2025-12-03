{
    pkgs,
    ...
}:
{
    home.packages = with pkgs; [
        nautilus
        gvfs

        # Thumbnailers for previews
        ffmpegthumbnailer   # For video thumbnails
        poppler-utils       # For PDF thumbnails
        webp-pixbuf-loader  # For .webp image thumbnails
        libheif             # For .heic/.avif image thumbnails
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "application/pdf" = [ "org.kde.okular.desktop" ];
      };
    };
}