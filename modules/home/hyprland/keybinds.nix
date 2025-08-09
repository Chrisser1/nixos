{ pkgs, lib, ... }:
let
  terminal = "${pkgs.kitty}/bin/kitty";
  mod = "SUPER";
  fm = "${pkgs.nautilus}/bin/nautilus";
in {
  wayland.windowManager.hyprland.settings = {
    bind = [
      "${mod}, S, exec, ${pkgs.firefox}/bin/firefox"
      "${mod} SHIFT, C, killactive"
      "${mod}, Q, exec, ${terminal}"
      "${mod}, Space, togglefloating,"
      "${mod}, R, exec, ${pkgs.wofi}/bin/wofi --show drun"
      "${mod}, M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      "${mod}, E, exec, ${fm}"
      "${mod} SHIFT, P, exec, shutdown now"
      "${mod}, G, exec, ${pkgs.firefox}/bin/firefox https://github.com/Chrisser1"
      "${mod} SHIFT, G, exec, ${pkgs.firefox}/bin/firefox https://gemini.google.com"


      "${mod}, 1, split-workspace, 1"
      "${mod}, 2, split-workspace, 2"
      "${mod}, 3, split-workspace, 3"
      "${mod}, 4, split-workspace, 4"
      "${mod}, 5, split-workspace, 5"
      "${mod}, 6, split-workspace, 6"
      "${mod}, 7, split-workspace, 7"
      "${mod}, 8, split-workspace, 8"
      "${mod}, 9, split-workspace, 9"

      "${mod} SHIFT, 1, split-movetoworkspace, 1"
      "${mod} SHIFT, 2, split-movetoworkspace, 2"
      "${mod} SHIFT, 3, split-movetoworkspace, 3"
      "${mod} SHIFT, 4, split-movetoworkspace, 4"
      "${mod} SHIFT, 5, split-movetoworkspace, 5"
      "${mod} SHIFT, 6, split-movetoworkspace, 6"
      "${mod} SHIFT, 7, split-movetoworkspace, 7"
      "${mod} SHIFT, 8, split-movetoworkspace, 8"
      "${mod} SHIFT, 9, split-movetoworkspace, 9"

      "${mod}, left, movefocus, l"
      "${mod}, right, movefocus, r"
      "${mod}, up, movefocus, u"
      "${mod}, down, movefocus, d"
    ];

    bindm = [
      "${mod}, mouse:272, movewindow"
      "${mod}, mouse:273, resizewindow"
    ];
  };
}
