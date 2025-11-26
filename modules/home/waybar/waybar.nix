{ 
  config, 
  pkgs, 
  ... 
}:
let
  scripts = import ./scripts.nix { inherit pkgs; };
  barConfig = import ./config.nix { inherit pkgs scripts; };
in {
  home.packages = with pkgs; [
    playerctl 
    wofi 
    jq 
    pavucontrol 
    libnotify
    scripts.wpctlSinkMenu
    scripts.wallpaperLabel
    scripts.wallpaperPicker
  ];

  programs.waybar = {
    enable = true;
    settings = barConfig;
  };

  home.file.".config/waybar/mocha.css".text  = builtins.readFile ./mocha.css;
  home.file.".config/waybar/style.css".text  = builtins.readFile ./style.css;
}