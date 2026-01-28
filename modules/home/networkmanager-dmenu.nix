{ pkgs, config, ... }: 
{
  home.packages = [ pkgs.networkmanager_dmenu ];

  # Define a separate config for the WiFi menu
  xdg.configFile."wofi/config-wifi".text = ''
    width=300
    height=400
    prompt=Networks
    filter_rate=100
    allow_markup=true
    no_actions=true
    halign=fill
    orientation=vertical
    content_halign=fill
    insensitive=true
    allow_images=true
    image_size=24
    gtk_dark=true
  '';

  # Configure networkmanager_dmenu
  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    # Point wofi to the custom config we just made
    dmenu_command = wofi --dmenu --conf ${config.home.homeDirectory}/.config/wofi/config-wifi
    compact = True
    pinentry = wofi --dmenu --prompt "Password" --password
    
    wifi_icons = 󰤯󰤟󰤢󰤥󰤨

    [editor]
    terminal = kitty
    gui_if_available = True
    gui = nm-connection-editor
  '';
}