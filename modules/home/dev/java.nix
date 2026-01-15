{
    pkgs,
    ...
}:
{
  home.packages = with pkgs; [
    jdk25
    jetbrains.idea
  ];

  home.file.".jdks/nixos-jdk25".source = "${pkgs.jdk25}/lib/openjdk";

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk25}/lib/openjdk";

    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.xorg.libXxf86vm
      pkgs.xorg.libXtst
      pkgs.libglvnd
      pkgs.gtk3             
      pkgs.glib
      pkgs.cairo
      pkgs.pango
      pkgs.atk
      pkgs.gdk-pixbuf
    ];
  };
}