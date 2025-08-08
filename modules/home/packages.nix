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
  ];

  # Optional apps
  extras = with pkgs; [
    discord
    prismlauncher
    spotify
  ];
in {
  home.packages = base ++ extras;
}
