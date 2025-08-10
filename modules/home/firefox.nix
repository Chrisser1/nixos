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

        settings = {
            # This setting tells Firefox to not disable newly installed extensions,
            # effectively enabling them by default.[1]
            "extensions.autoDisableScopes" = 0;

            # This sets the browser's UI theme to the default dark theme.[2]
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

            # This forces web content to prefer a dark color scheme,
            # which enables dark mode on compatible websites.[3, 4]
            "layout.css.prefers-color-scheme.content-override" = 0;
        };
    };
  };
}