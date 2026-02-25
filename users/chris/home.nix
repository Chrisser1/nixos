{ 
    pkgs,
    ... 
}:
{
  imports = [
    ../common.nix

    # Developer
    ../../modules/home/dev/dotnet.nix
    # ../../modules/home/dev/chisel.nix
    ../../modules/home/dev/java.nix
    ../../modules/home/dev/go.nix
    # ../../modules/home/dev/javascript.nix
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

    # Minecraft
    prismlauncher

    # Offline wikipedia reader
    kiwix

    # Jet
    jetbrains.clion
    jetbrains.rider
    steam-run
    jetbrains-toolbox
    jetbrains.goland
  ];
}