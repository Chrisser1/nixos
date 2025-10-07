{ 
    pkgs, 
    inputs, 
    lib, 
    ... 
}:
{
  # Cursor theme across Wayland + XWayland
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    settings = {
      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        # "col.active_border"   = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.active_border" = "rgba(880808ff)";
        "col.inactive_border" = "rgba(595959ff)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      group = {
        insert_after_current = true;
        focus_removed_window = true;
        "col.border_active" = "rgba(880808ff)";
        "col.border_inactive" = "rgba(595959ff)";

        # Groupbar (Tabbed view) configuration
        groupbar = {
            enabled = true;
            render_titles = true; 
            gradients = true;
            font_size = 16;
            font_weight_active = "ultraheavy";
            height = 24;
            text_color = "rgba(33ccffee)";
            text_color_inactive = "rgba(33ccffee)";
            "col.active" = "rgba(880808ff)";          # Was rgba(89b4faff)
            "col.inactive" = "0xff45475a";        # Was rgba(45475aff)
            "col.locked_active" = "0xfff38ba8";
        };
      };

      decoration = {
        rounding = 0;
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

      # Base autostart: host files can append with lib.mkAfter
      exec-once = [
        "${pkgs.waybar}/bin/waybar"
        "wpaperd -d"
      ];

      input = {
        kb_layout = "dk";
        follow_mouse = 1;
        force_no_accel = 1;
        sensitivity = 1;
        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
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
