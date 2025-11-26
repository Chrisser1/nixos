{ config, pkgs, ... }:
{
  # Link backgrounds directory so it exists
  home.file."${config.xdg.configHome}/backgrounds" = {
    source = ../../assets/backgrounds;
    recursive = true;
  };

  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "${config.home.homeDirectory}/.local/state/wpaperd/selected";
        mode = "center";
        sorting = "ascending";
      };
    };
  };
}