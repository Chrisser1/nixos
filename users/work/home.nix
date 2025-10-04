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

  services.tailscale.enable = true;
  home.packages = with pkgs; [
    tailscale
  ];
}