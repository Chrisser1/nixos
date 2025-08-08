{ 
    pkgs, 
    inputs, 
    lib, 
    ... 
}:
{
  home = {
    username = "chris";
    homeDirectory = "/home/chris";
    stateVersion = "25.05";
  };

  # Pull in your shared HM stack (kitty, starship, hyprland, waybar, etc.)
  imports = [
    ../../modules/home
  ];
}