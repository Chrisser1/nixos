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

  home.packages = with pkgs; [
    tailscale
  ];
}