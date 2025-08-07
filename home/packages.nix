{pkgs, ...}: let
  default = with pkgs; [
    fastfetch
    discord
    prismlauncher
    waybar
    spotify
		tmux

    # wallpapers
    wpaperd          # provides `wpaperd` and `wpaperctl`

    # media/brightness keys from your binds
    playerctl
    brightnessctl

    # screenshots/lock from your binds
    hyprshot         # uses grim + slurp etc. under the hood
    hyprlock
  ];
in {
  nixpkgs.config.allowUnfree = true;
  home.packages = default;
}
