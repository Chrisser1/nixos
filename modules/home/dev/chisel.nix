{
    pkgs,
    ...
}:
{
  home.packages = with pkgs; [
    jdk21
    sbt 
    gtkwave
    surfer 
    jetbrains.idea-ultimate
  ];

  home.sessionVariables = {
      JAVA_HOME = "${pkgs.jdk21}";
  };
}