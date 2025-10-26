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
      shellAliases = let
        flakePath = "$HOME/nixos";
      in {
        # Aliases from bash.nix
        vim = "nvim";
        rebuild = "sudo nixos-rebuild switch --flake path:${flakePath}#$(hostname)";
        update = "sudo nixos-rebuild switch --upgrade --flake path:${flakePath}#$(hostname)";
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