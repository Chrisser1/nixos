{inputs, ...}: {
  flake.nixosModules.noctalia = {...}: {
    imports = [inputs.noctalia.nixosModules.default];
    programs.noctalia = {
      enable = true;
      package = null;
      recommendedServices.enable = true;
    };
  };

  flake.homeModules.noctalia = {...}: {
    imports = [inputs.noctalia.homeModules.default];
    programs.noctalia = {
      enable = true;
      settings = {
        theme = {
          source = "builtin";
          builtin = "Ayu";
          mode = "dark";
          templates = {
            enable_builtin_templates = true;
            enable_community_templates = true;
            builtin_ids = ["btop" "gtk3" "gtk4" "hyprland" "kitty" "qt"];
            community_ids = ["discord" "hyprtoolkit" "obsidian" "rofi" "steam" "vscode"];
          };
        };
        wallpaper.directory = "/home/chris/nixos/assets/backgrounds/berserk";
      };
    };
  };
}
