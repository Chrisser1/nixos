{ pkgs, lib, ... }:
let
  base = with pkgs; [
    fastfetch
    tmux

    # wallpapers + helpers
    wpaperd          # you exec it in Hyprland
    playerctl
    brightnessctl

    # screenshots/lock from your binds
    hyprshot
    hyprlock

    nautilus
    gvfs

    obsidian

    # For waybar click to get wifi
    networkmanager_dmenu

    bluez
    bluez-tools

    # Utils
    wget
    git-lfs
    zip
    unzip
    direnv
  ];
  
  
  
  # Optional apps
  extras = with pkgs; [
    discord
    prismlauncher
    spotify
    jetbrains.clion
    jetbrains.rider
    
    # Used for operation systems DTU (for vm's)
    vagrant
  ];
in {
  home.packages = base ++ extras;
}
