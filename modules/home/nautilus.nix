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
        poppler_utils       # For PDF thumbnails
        webp-pixbuf-loader  # For .webp image thumbnails
        libheif             # For .heic/.avif image thumbnails

        # GVFS Backends for connections
        gvfs-mtp            # For Android phones (MTP)
        gvfs-gphoto2        # For digital cameras
        gvfs-smb            # For Windows/Samba network shares
    ];

    # Set Nautilus as the default file manager
    xdg.mimeApps.defaultApplications."inode/directory" = [ "org.gnome.Nautilus.desktop" ];
}