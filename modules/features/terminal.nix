{ self, ... }: {
  flake.nixosModules.feature-terminal = { pkgs, ... }: {
    programs.fish.enable = true; 
  };
  
  flake.homeModules.feature-terminal = { pkgs, lib, ... }: {
    # --- Kitty Terminal ---
    programs.kitty = {
      enable = true;
      font = {
        name = "CaskaydiaCove Nerd Font";
        size = 12;
      };
      settings = {
        # Berserk theme colors
        background = "#171717";
        foreground = "#EDE6DB";
        selection_background = "#7F0909";
        
        # Clean look and feel
        enable_audio_bell = false;
        window_padding_width = 4;
        hide_window_decorations = "yes";
      };
    };

    # --- Fish Shell ---
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -gx MAMBA_EXE "${pkgs.micromamba}/bin/micromamba"
        set -gx MAMBA_ROOT_PREFIX "$HOME/micromamba"
        eval "$($MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX)"
      '';
      shellAliases = let
        flakePath = "$HOME/nixos";
      in {
        vim = "nvim";
        rebuild = "nh os switch ~/nixos -- --impure";
        update = "nh os switch ~/nixos --update -- --impure";
        clean = "nh clean all --keep 3 && rm -rf ~/.local/share/Trash/*";
        usage = "gdu /";
        store-map = "nix-tree -- /run/current-system";
        roots = "nix-store --gc --print-roots | grep -v '/proc/'";
        hms = "home-manager switch --flake ${flakePath}#$(hostname)";
        dn = "dotnet";
        db = "dotnet build";
        dr = "dotnet run";
        dt = "dotnet test";
        ssh = "kitten ssh";
      };
    };

    # --- Terminal Utilities ---
    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      extraOptions = [ "--icons" "--group-directories-first" ];
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    
    programs.bat = {
      enable = true;
      config.theme = "Dracula"; 
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}