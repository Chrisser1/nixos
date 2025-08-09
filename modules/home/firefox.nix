{ 
    pkgs, 
    ... 
}:
{
  programs.firefox = {
    enable = true;
    # Let Nix manage the extensions.
    extensions = with pkgs.firefox-addons; [
      ublock-origin
      bitwarden
      grammarly
    ];
  };
}