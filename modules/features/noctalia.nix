 { self, inputs, ... }: {

  perSystem = { pkgs, lib, ... }: {

    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {

      inherit pkgs;

      settings = lib.recursiveUpdate (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings {

        # Dynamically copying assets to the Nix store

        general.avatarImage = "${../../assets/backgrounds/berserk/Knight.png}";

        wallpaper.directory = "${../../assets/backgrounds}";

      };

    };

  };

} 