{ 
  pkgs, 
  config,
  lib,
  ... 
}:
{
  config = lib.mkIf (config.my.shell == "bash") {
    programs.bash = {
      enable = true;
      shellAliases = let
        flakePath = "$HOME/nixos";
      in {
        vim = "nvim";
        rebuild = "nh os switch ~/nixos -- --impure";
        update = "nh os switch ~/nixos --update -- --impure";
        clean = "nh clean all --keep 3";
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
 
