{ pkgs, lib, ... }:
let
  btop-nvidia = pkgs.btop.override {
    cudaSupport = true;
  };

  base = with pkgs; [
    # --- System Utilities ---
    fastfetch
    tmux
    wget
    zip
    unzip
    dbus
    jq
    bc
    fd              # Faster 'find'
    ripgrep         # Faster 'grep'
    tldr            # Simpler 'man' pages
    tree            # Directory visualization
    
    # --- Connectivity ---
    networkmanager_dmenu
    bluez
    bluez-tools

    # --- Document Handling ---
    pandoc
    poppler-utils
    texlive.combined.scheme-small
    ocrmypdf
    libreoffice

    # --- Media / Visuals ---
    wpaperd
    playerctl
    brightnessctl

    # --- Nix Tools ---
    nh
    nix-output-monitor
    nix-tree

    # --- Monitoring ---
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
