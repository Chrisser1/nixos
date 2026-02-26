{
    pkgs,
    config,
    lib,
    ...
}:
{
  config = lib.mkIf (config.my.shell == "fish") {
    programs.fish = {
      enable = true;
      
      interactiveShellInit = ''
        set -gx MAMBA_EXE "${pkgs.micromamba}/bin/micromamba"
        set -gx MAMBA_ROOT_PREFIX "$HOME/micromamba"
        $MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
      '';

      shellAliases = let
        flakePath = "$HOME/nixos";
      in {
        vim = "nvim";
        rebuild = "nh os switch ~/nixos -- --impure";
        update = "nh os switch ~/nixos --update -- --impure";

        # File cleaning utils
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
  };
}