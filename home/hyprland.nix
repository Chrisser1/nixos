{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  terminal = pkgs.alacritty + "/bin/alacritty";
  mod = "SUPER";
in {
  home = {
    packages = [ pkgs.wpaperd ];
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
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;

        # keys with dots need quoting in Nix
        "col.active_border"   = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        # your old "yes, please :)" → boolean true here
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      env = [
        "XCURSOR_THEME,Adwaita"
        "XCURSOR_SIZE,24"
      ];

      exec-once = [
        "${pkgs.waybar}/bin/waybar"
        "wpaperd -d"
      ];

      bind = [
        "${mod}, S, exec, ${pkgs.firefox}/bin/firefox"
        "${mod}_SHIFT, C, killactive"
        "${mod}, Q, exec, ${terminal}"
        "${mod}, Space, togglefloating,"
        "${mod}, R, exec, ${pkgs.wofi}/bin/wofi --show drun"
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
