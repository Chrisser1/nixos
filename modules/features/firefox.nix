{ self, inputs, ... }: {
  
  flake.homeModules.feature-firefox = { pkgs, lib, config, ... }: 
  let
    addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs.firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
      
      languagePacks = [ "en-US" ];

      policies = {
        # Updates & Background Services
        AppAutoUpdate                 = false;
        BackgroundAppUpdate           = false;

        # Feature Disabling
        DisableBuiltinPDFViewer       = true;
        DisableFirefoxStudies         = true;
        DisableFirefoxAccounts        = true;
        DisableFirefoxScreenshots     = true;
        DisableForgetButton           = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport          = true;
        DisableProfileRefresh         = true;
        DisableSetDesktopBackground   = true;
        DisablePocket                 = true;
        DisableTelemetry              = true;
        DisableFormHistory            = true;
        DisablePasswordReveal         = true;

        # Access Restrictions
        BlockAboutConfig              = false;
        BlockAboutProfiles            = true;
        BlockAboutSupport             = true;

        # UI and Behavior
        DisplayMenuBar                = "never";
        DontCheckDefaultBrowser       = true;
        HardwareAcceleration          = false;
        OfferToSaveLogins             = false;
        DefaultDownloadDirectory      = "${config.home.homeDirectory}/Downloads";

        # Extensions
        ExtensionSettings = let
          moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        in {
          # This blocks all extensions by default
          "*".installation_mode = "blocked";

          # Allow Bitwarden (installed via extensions.packages below)
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            installation_mode = "allowed";
          };

          "uBlock0@raymondhill.net" = {
            install_url       = moz "ublock-origin";
            installation_mode = "force_installed";
            updates_disabled  = true;
          };

          "{f3b4b962-34b4-4935-9eee-45b0bce58279}" = {
            install_url       = moz "animated-purple-moon-lake";
            installation_mode = "force_installed";
            updates_disabled  = true;
          };

          # "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
          #   install_url       = moz "noscript";
          #   installation_mode = "force_installed";
          #   updates_disabled  = true;
          # };
        };

        # Extension configuration 
        "3rdparty".Extensions = {
          "uBlock0@raymondhill.net".adminSettings = {
            userSettings = rec {
              uiTheme            = "dark";
              uiAccentCustom     = true;
              uiAccentCustom0    = "#8300ff";
              cloudStorageEnabled = lib.mkForce false;

              importedLists = [
                "https://filters.adtidy.org/extension/ublock/filters/3.txt"
                "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
              ];

              externalLists = lib.concatStringsSep "\n" importedLists;
            };

            selectedFilterLists = [
              "CZE-0"
              "adguard-generic"
              "adguard-annoyance"
              "adguard-social"
              "adguard-spyware-url"
              "easylist"
              "easyprivacy"
              "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
              "plowe-0"
              "ublock-abuse"
              "ublock-badware"
              "ublock-filters"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "urlhaus-1"
            ];
          };
        };
      };

      profiles.chris = {
        isDefault = true;

        extensions.packages = [
          addons.bitwarden
        ];

        settings = {
          "extensions.autoDisableScopes" = 0;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "layout.css.prefers-color-scheme.content-override" = 0;
        };

        search = {
          force           = true;
          default         = "google";
          privateDefault  = "ddg";

          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query";   value = "{searchTerms}"; }
                ];
              }];
              icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "Nix Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query";   value = "{searchTerms}"; }
                ];
              }];
              icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            "NixOS Wiki" = {
              urls = [{
                template = "https://wiki.nixos.org/w/index.php";
                params = [
                  { name = "search"; value = "{searchTerms}"; }
                ];
              }];
              icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };
          };
        };
      };
    };
  };
}