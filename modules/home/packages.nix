{ pkgs, lib, ... }:
let
  base = with pkgs; [
    # Terminal + shell
    fastfetch
    tmux

    # wallpapers + helpers
    wpaperd          # you exec it in Hyprland
    playerctl
    brightnessctl

    # screenshots/lock from your binds
    hyprshot
    hyprlock

    # For waybar click to get wifi
    networkmanager_dmenu

    # Bluetooth support
    bluez
    bluez-tools

    # Utils
    wget
    git-lfs
    zip
    unzip
    direnv
    dbus
    btop
  ];
  
  
  
  # Optional apps
  extras = with pkgs; [
    discord
    spotify
  ];
in {
  home.packages = base ++ extras;
}
