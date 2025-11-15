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

    # Set Nautilus as the default file manager
    xdg.mimeApps.defaultApplications."inode/directory" = [ "org.gnome.Nautilus.desktop" ];
}