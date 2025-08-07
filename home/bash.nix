{
  programs.bash = {
    enable = true;
    shellAliases = let
      flakePath = "~/nixos";
    in {
      vim = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake ${flakePath}#$(hostname)";
			hms = "home-manager switch --flake ${flakePath}#$(hostname)";
    };
  };
}
