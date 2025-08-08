{ 
  config, 
  pkgs, 
  lib, 
  ... 
}:
{
  # Keep the binary with the module to avoid chasing it in packages.nix
  home.packages = [ pkgs.wpaperd ];

  home.file."${config.xdg.configHome}/backgrounds" = {
    source = ../../assets/backgrounds;
    recursive = true;
  };

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
