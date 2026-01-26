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
        # Aliases from bash.nix
        vim = "nvim";
        rebuild = "nh os switch ~/nixos"; 
        update = "nh os switch ~/nixos --update";
        clean = "nh clean all --keep 3";
        hms = "home-manager switch --flake ${flakePath}#$(hostname)";

        # Aliases from dotnet.nix
        dn = "dotnet";
        db = "dotnet build";
        dr = "dotnet run";
        dt = "dotnet test";

        ssh = "kitten ssh";
      };
    };
  };
}