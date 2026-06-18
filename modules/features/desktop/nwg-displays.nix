{...}: {
  flake.homeModules.nwg-displays = {pkgs, ...}: {
    home.packages = [pkgs.nwg-displays];
  };
}
