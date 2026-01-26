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
    ./terminal/utils.nix

    # Hyprland split
    ./hyprland/core.nix
    ./hyprland/keybinds.nix
    
    # Users
    ./powermenu.nix
    ./hyprlock.nix

    # Visuals
    ./waybar/waybar.nix
    ./wofi.nix
    ./wpaperd.nix

    # Utilities
    ./git.nix
    ./hyprshot.nix
    ./firefox.nix
    ./nautilus.nix

    # Developer stuff
    ./dev/vscode.nix
    ./dev/search.nix
    ./dev/db.nix

    # Network management
    ./networkmanager-dmenu.nix
  ];
  
  # Pretty, featureful (wayland)
  services.swaync.enable = true;
  # or tiny & simple
  # services.mako.enable = true;
}
