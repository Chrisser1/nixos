{ 
    pkgs,
    ... 
}:
{
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

    # Notes
    obsidian

    # Jet
    jetbrains.clion
    jetbrains.rider
    steam-run
    jetbrains-toolbox
  ];
}