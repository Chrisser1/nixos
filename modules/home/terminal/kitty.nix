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
    themeFile = "Catppuccin-Mocha";

    shellIntegration = {
      enableFishIntegration = lib.mkIf (config.my.shell == "fish") true;
      enableBashIntegration = lib.mkIf (config.my.shell == "bash") true;
    };
  };
}
