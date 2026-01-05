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
  };
}