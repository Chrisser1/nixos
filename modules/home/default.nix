{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./packages.nix
    
    # Terminal
    ./terminal/kitty.nix
    ./terminal/starship.nix
    ./terminal/bash.nix

    # Hyprland split
    ./hyprland/core.nix
    ./hyprland/keybinds.nix

    # Visuals
    ./waybar.nix
    ./wofi.nix
    ./wpaperd.nix

    # Utilities
    ./git.nix
    ./vscode.nix
    ./hyprshot.nix
    ./firefox.nix

    # Developer stuff
    ./dev/python.nix
    ./dev/dotnet.nix
    ./dev/clion.nix

    # Network management
    ./networkmanager-dmenu.nix
  ];
  
  # Pretty, featureful (wayland)
  services.swaync.enable = true;
  # or tiny & simple
  # services.mako.enable = true;
}
