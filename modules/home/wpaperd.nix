{ 
  config, 
  pkgs, 
  lib, 
  ... 
}:
{
  # Keep the binary with the module to avoid chasing it in packages.nix
  home.packages = [ pkgs.wpaperd ];

  # Link repo backgrounds into the config dir
  home.file."${config.xdg.configHome}/backgrounds" = lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos/assets/backgrounds";

  # Minimal TOML pointing at the stable location
  home.file."${config.xdg.configHome}/wpaperd/config.toml".text = ''
    [default]
    path = "${config.xdg.configHome}/backgrounds"
    sorting = "random"
    duration = "30m"
    recursive = true
    mode = "fit"
  '';
}
