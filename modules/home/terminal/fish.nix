{
    pkgs,
    config,
    ...
}:
{
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

      # Alias from python.nix
      conda = "micromamba";

      # Aliases from dotnet.nix
      dn = "dotnet";
      db = "dotnet build";
      dr = "dotnet run";
      dt = "dotnet test";
    };
    # Sets up the micromamba hook for fish
    interactiveShellInit = ''
      eval "$(${pkgs.micromamba}/bin/micromamba shell hook --shell fish)"
      set fish_greeting ""
    '';
  };
}