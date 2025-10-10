{ 
  pkgs, 
  ... 
}:
{
  programs.bash = {
    enable = true;
    shellAliases = let
      flakePath = "$HOME/nixos";
    in {
      vim = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake path:${flakePath}#$(hostname)";
      update = "sudo nixos-rebuild switch --upgrade --flake path:${flakePath}#$(hostname)";
			hms = "home-manager switch --flake ${flakePath}#$(hostname)";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
 
