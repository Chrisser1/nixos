{ pkgs, inputs, ... }:

let
  # This makes sure we are using the 'nixpkgs' flake input you defined
  # and not some other version of pkgs that might be getting passed accidentally.
  firefox-addons = inputs.nixpkgs.legacyPackages.${pkgs.system}.firefox-addons;
in
{
  programs.firefox = {
    enable = true;
    profiles.chris = {
      isDefault = true;
      extensions.packages = [
        firefox-addons.ublock-origin
        firefox-addons.bitwarden
        firefox-addons.grammarly
      ];
    };
  };
}