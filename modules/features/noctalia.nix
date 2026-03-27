{ self, inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      binName = "noctalia"; 

      settings = let
        screenShotSrc = pkgs.fetchFromGitHub {
          owner = "Chrisser1";
          repo = "noctalia-screen-shot-and-record";
          rev = "master"; 
          hash = "sha256-62x7NfyL1zDFQrh5dZuTAM+zH1I5lRLvctAJZbWhyL8=";
        };

        screenShotPlugin = pkgs.runCommand "format-plugin-dir" {} ''
          mkdir -p $out/screen-shot-and-record
          cp -r ${screenShotSrc}/* $out/screen-shot-and-record/
        '';

        baseConfig = builtins.fromJSON (builtins.readFile ./noctalia.json);
      in 
        lib.recursiveUpdate baseConfig.settings {
          general.avatarImage = "${../../assets/backgrounds/berserk/Knight.png}";
          wallpaper.directory = "${../../assets/backgrounds}";

          plugins.screen-shot-and-record = {
            enabled = true;
            sourceUrl = "local";
            path = "${screenShotPlugin}/screen-shot-and-record";
          };
        };
    };
  };
}