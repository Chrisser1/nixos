{ 
    pkgs,
    ... 
}:
{


  # Pull in your shared HM stack (kitty, starship, hyprland, waybar, etc.)
  imports = [
    ../common.nix

    # Developer
    ../../modules/home/dev/dotnet.nix
    ../../modules/home/dev/chisel.nix
  ];

  home = {
    username = "chris";
    homeDirectory = "/home/chris";
  };

  my.shell = "fish";

  home.packages = with pkgs; [
    # Used for operation systems DTU (for vm's)
    vagrant

    # Jet
    jetbrains.clion
    jetbrains.rider
    steam-run
    jetbrains-toolbox
  ];
}