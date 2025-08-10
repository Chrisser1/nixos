{ pkgs, ... }:
{
  # Declaratively configure it to use wofi as the frontend.
  xdg.configFile."networkmanager_dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = wofi --show dmenu --prompt "Select Network"
  '';
}