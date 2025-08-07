{
  config,
  pkgs,
  inputs,
	lib,
  ...
}: {
  home = {
    username = "chris";
    homeDirectory = "/home/chris";
    stateVersion = "25.05";
		};
  wayland.windowManager.hyprland.settings = {
    monitor = [",preferred,auto,1"];
    exec-once = [
      # Mute the default audio sink at startup
      "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
    ];
  };
  programs.waybar.settings.mainBar.modules-right = [
    "battery"
    "custom/divider"
  ];
}
