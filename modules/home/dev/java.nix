{
    pkgs,
    ...
}:
{
  home.packages = with pkgs; [
    jdk25
    jetbrains.idea-ultimate
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk25}";
  };
}