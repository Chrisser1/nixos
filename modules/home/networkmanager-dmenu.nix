{ pkgs, config, ... }: 
{
  home.packages = [ pkgs.networkmanager_dmenu ];

  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]½
    dmenu_command = rofi -dmenu -p "Network"
    compact = True
    pinentry = rofi -dmenu -p "Password" -password
    
    wifi_icons = 󰤯󰤟󰤢󰤥󰤨

    [editor]
    terminal = kitty
    gui_if_available = True
  '';
}