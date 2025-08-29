{
  config,
  pkgs,
  inputs,
	lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    monitor = [",preferred,auto,2"];
    exec-once = lib.mkAfter [
      "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
    ];
  };

  # Enable the CLion wrapper and set the scale to 2
  wayland.clion = {
    enable = true;
    scale = 2.0;
  };
}
