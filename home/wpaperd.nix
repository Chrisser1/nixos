# e.g. home/wpaperd.nix
{ config, pkgs, ... }:
{
  home.packages = [ pkgs.wpaperd ];

  # Link the repo folder into ~/.config/backgrounds
  home.file.".config/backgrounds" = {
    source = ../assets/bagrounds;   
    recursive = true;               
  };

  # Keep TOML pointing to the stable location
  home.file.".config/wpaperd/config.toml".text = ''
    [default]
    path = "${config.home.homeDirectory}/.config/backgrounds"
    sorting = "random"
    duration = "30m"
    recursive = true
    mode = "fill"
  '';
}
