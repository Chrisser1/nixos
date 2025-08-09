# This module now expects `firefox-addons` to be passed as an argument
{ pkgs, firefox-addons, lib, ... }:

let
  # Define a local variable for the addon packages from the correct source
  addons = firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox = {
    enable = true;
    profiles.chris = {
      isDefault = true;

      # Use the modern `extensions.packages` option [1]
      extensions.packages = [
        addons.ublock-origin
        addons.bitwarden
      ];
    };
  };
}