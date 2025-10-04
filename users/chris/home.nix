{ 
    pkgs, 
    ... 
}:
{
  # Pull in your shared HM stack (kitty, starship, hyprland, waybar, etc.)
  imports = [
    ../common.nix
  ];

  home = {
    username = "chris";
    homeDirectory = "/home/chris";
  };

  home.packages = with pkgs; [
    # Used for operation systems DTU (for vm's)
    vagrant
  ];
}