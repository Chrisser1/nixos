{ self, inputs, ... }: {
  
  flake.homeModules.feature-firefox = { pkgs, lib, config, ... }: 
  let
    addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles.chris = {
        isDefault = true;

        extensions.packages = [
          addons.ublock-origin
          addons.bitwarden
        ];

        settings = {
          # This setting tells Firefox to not disable newly installed extensions,
          # effectively enabling them by default.
          "extensions.autoDisableScopes" = 0;

          # This sets the browser's UI theme to the default dark theme.
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

          # This forces web content to prefer a dark color scheme,
          # which enables dark mode on compatible websites.
          "layout.css.prefers-color-scheme.content-override" = 0;
        };
      };
    };
  };
}