{
  config,
  pkgs,
  inputs,
	lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    monitor = [",preferred,auto,1"];
    exec-once = lib.mkAfter [
      "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
    ];
  };
}
