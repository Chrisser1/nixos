{ 
    pkgs, 
    ... 
}:
{
  imports = [
    ../common.nix
  ];

  home = {
    username = "work";
    homeDirectory = "/home/work";
  };

  my.shell = "fish";

  home.packages = with pkgs; [
    tailscale
  ];
}