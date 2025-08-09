{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./packages.nix

    ./terminal/kitty.nix
    ./terminal/starship.nix
    ./terminal/bash.nix

    # Hyprland split
    ./hyprland/core.nix
    ./hyprland/keybinds.nix

    ./waybar.nix
    ./git.nix
    ./vscode.nix
    ./hyprshot.nix
    ./wofi.nix
    ./wpaperd.nix

    # Developer stuff
    ./dev/python.nix
  ];
  
  # Pretty, featureful (wayland)
  services.swaync.enable = true;
  # or tiny & simple
  # services.mako.enable = true;
}
