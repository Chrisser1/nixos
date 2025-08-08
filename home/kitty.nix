{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;

    # Font (Nerd Font w/ glyphs for Starship)
    font = {
      package = pkgs.nerd-fonts.caskaydia-cove; # installs the font
      name = "CaskaydiaCove Nerd Font";
      size = 14;
    };

    settings = {
      background_opacity = "0.9";
      # If you want to keep using the “current-theme.conf” include:
      # include = "current-theme.conf";
    };

    # EITHER: let HM manage theme from kitty-themes
    # (works with most themes, including Catppuccin)
    themeFile = "Catppuccin-Mocha";
  };
}
