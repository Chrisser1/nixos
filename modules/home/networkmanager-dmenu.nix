{ pkgs, ... }:
{
  home.packages = [ pkgs.networkmanager_dmenu ];

  # Configure the visual settings
  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = wofi --dmenu --prompt "Wifi Networks"
    compact = True
    pinentry = wofi --dmenu --prompt "Password" --password
    
    # Custom colors for the wifi signal bars
    # Using standard icons for signal strength
    wifi_icons = 󰤯󰤟󰤢󰤥󰤨

    [editor]
    terminal = kitty
    gui_if_available = True
  '';
}