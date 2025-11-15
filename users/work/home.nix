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
    dconf
    dbeaver-bin

    gnome-online-accounts
    gnome-control-center
  ];
}