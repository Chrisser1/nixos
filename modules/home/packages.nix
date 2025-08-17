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
  ];
  
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # required per nixos wiki page on VS Code
  
  # Optional apps
  extras = with pkgs; [
    discord
    prismlauncher
    spotify
  ];
in {
  home.packages = base ++ extras;
}
