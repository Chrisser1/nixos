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
      # Aliases from your old bash.nix
      vim = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake path:${flakePath}#$(hostname)";
      update = "sudo nixos-rebuild switch --upgrade --flake path:${flakePath}#$(hostname)";
      hms = "home-manager switch --flake ${flakePath}#$(hostname)";

      # Alias from your python.nix
      conda = "micromamba";
    };

    # This sets up the micromamba hook for fish
    interactiveShellInit = ''
      eval "$(${pkgs.micromamba}/bin/micromamba shell hook --shell fish)"
    '';
  };

  # Set fish as the default shell for your user
  users.defaultUserShell = pkgs.fish;
}