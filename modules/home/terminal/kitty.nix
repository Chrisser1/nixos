{ 
  config, 
  pkgs, 
  lib, 
  ... 
}:
{
  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.nerd-fonts.caskaydia-cove;
      name = "CaskaydiaCove Nerd Font";
      size = 14;
    };

    settings = {
      background_opacity = "0.9";
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
    };

    # Reliable theme hook through kitty-themes
    theme = "Catppuccin-Mocha";

    # (Optional) prompt/URL handlers etc.
    shellIntegration.enableBashIntegration = true;
  };
}
