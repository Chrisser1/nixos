{
    pkgs,
    ...
}:
{
  home.packages = with pkgs; [
    jdk17
    sbt 
    gtkwave
    surfer 
    jetbrains.idea-ultimate
  ];

  home.sessionVariables = {
      JAVA_HOME = "${pkgs.jdk17}";
  };
}