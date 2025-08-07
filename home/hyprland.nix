{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  wallpaper = ../assets/wallpaper.png;
  terminal = pkgs.alacritty + "/bin/alacritty";
  mod = "SUPER";
  startupScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    swww-daemon &
    swww img ${wallpaper}
  '';
in {
  home = {
    packages = [ pkgs.swww ];
    pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    settings = {
      general = {
        gaps_in = 10;
        gaps_out = 10;
      };

      animations = {
        enabled = true;
        animation = [
          "workspaces, 0, 1, default"
        ];
      };

      env = [
        "XCURSOR_THEME,Adwaita"
        "XCURSOR_SIZE,24"
      ];

      exec-once = ["${startupScript}/bin/start"];
      bind = [
        "${mod}, Q, exec, ${pkgs.firefox}/bin/firefox"
        "${mod}_SHIFT, C, killactive"
        "${mod}, Return, exec, ${terminal}"
        "${mod}, Space, togglefloating,"
        "${mod}, S, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "${mod}, M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

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
      ];

      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];

      input = {
        kb_layout = "dk";
        follow_mouse = 1;
        sensitivity = 1;
        touchpad = {
          disable_while_typing = true;
          natural_scroll = true; # Enable "natural" scrolling (like macOS)
          #natural_scroll = false; # Disable (traditional scrolling)
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
      };
    };
    extraConfig = ''
      plugin:split-monitor-workspaces:enable_persistent_workspaces = 0
    '';
  };
}
