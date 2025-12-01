{ pkgs, lib, ... }:
let
  btop-nvidia = pkgs.btop.override {
    cudaSupport = true;
  };

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
    ocrmypdf
    libreoffice
    wget
    git-lfs
    zip
    unzip
    direnv
    dbus
    jq
    bc

    # System monitors
    btop-nvidia
  ];
  
  
  
  # Optional apps
  extras = with pkgs; [
    discord
    spotify
  ];
in {
  home.packages = base ++ extras;
}
