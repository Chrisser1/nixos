{
    pkgs,
    ...
}:
{
  home.packages = with pkgs; [
    jdk25
    jetbrains.idea-ultimate
  ];

  home.file.".jdks/nixos-jdk25".source = pkgs.jdk25;

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk25}";
  };
}