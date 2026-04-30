{ self, inputs, ... }: {
  flake.nixosModules.feature-hyprland = { pkgs, lib, ... }: {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      xwayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      config = {
        hyprland = {
          default = [ "hyprland" "gtk" ];
        };
      };
      
      extraPortals = lib.mkForce [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  flake.homeModules.feature-hyprland = { pkgs, config, lib, ... }: 
  let
    terminal = "${pkgs.kitty}/bin/kitty";
    mod = "SUPER";
    fm = "${pkgs.nautilus}/bin/nautilus";

    noctalia-pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
    noctalia = "${noctalia-pkg}/bin/noctalia-shell";
  in {
    home.packages = [ noctalia-pkg ];    

    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      plugins = [
        inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
      ];
      
      settings = {
        general = {
          gaps_in = 2; gaps_out = 2; border_size = 2;
          "col.active_border" = "rgba(880808ff)";
          "col.inactive_border" = "rgba(595959ff)";
          resize_on_border = true; allow_tearing = false; layout = "dwindle";
        };
        
        group = {
          insert_after_current = true; 
          focus_removed_window = true;
          "col.border_active" = "rgba(880808ff)"; 
          "col.border_inactive" = "rgba(595959ff)";

          groupbar = {
                enabled = true;
                render_titles = true; 
                gradients = true;
                font_size = 16;
                font_weight_active = "ultraheavy";
                height = 24;
                text_color = "rgba(33ccffee)";
                text_color_inactive = "rgba(33ccffee)";
                "col.active" = "rgba(880808ff)";          
                "col.inactive" = "0xff45475a";        
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
            "QT_QPA_PLATFORMTHEME,qt6ct"
        ];
        
        exec-once = [
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME"
            "${noctalia}"
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

        bind = let
          # Automatically generate workspace binds 1 through 9 for your specific plugin
          woworkspaces = map (n: "${mod}, ${toString n}, split-workspace, ${toString n}") [1 2 3 4 5 6 7 8 9];
          moveworkspaces = map (n: "${mod} SHIFT, ${toString n}, split-movetoworkspace, ${toString n}") [1 2 3 4 5 6 7 8 9];
        in [
            # Apps & Shell
            "${mod}, S, exec, ${pkgs.firefox}/bin/firefox"
            "${mod} SHIFT, C, killactive"
            "${mod}, Q, exec, ${terminal}"
            "${mod}, Space, togglefloating,"
            "${mod}, E, exec, ${fm}"

            # Noctalia IPC Binds
            "${mod} SHIFT, S, exec, sh -c 'PLUGIN_ID=$(${noctalia} ipc call state all | grep -oE \"[0-9a-f]{6}:screen-shot-and-record\" | head -n 1); ${noctalia} ipc call plugin togglePanel $PLUGIN_ID'"
            "${mod}, U, exec, ${noctalia} ipc call sessionMenu toggle"
            "${mod}, V, exec, ${noctalia} ipc call launcher clipboard"
            "${mod}, R, exec, ${noctalia} ipc call launcher toggle"
            "ALT, SPACE, exec, ${noctalia} ipc call launcher toggle"
            "${mod}, M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

            # Web Bookmarks
            "${mod} SHIFT, G, exec, ${pkgs.firefox}/bin/firefox https://github.com/Chrisser1"
            "${mod}, L, exec, ${pkgs.firefox}/bin/firefox https://learn.inside.dtu.dk/d2l/home"
            "${mod} SHIFT, L, exec, ${pkgs.firefox}/bin/firefox https://studieplan.dtu.dk/"

            # Groups
            "${mod}, G, togglegroup"
            "${mod}, TAB, changegroupactive, f"
            "${mod}  SHIFT, TAB, changegroupactive, b"
            "${mod}, F, moveoutofgroup"

            # Focus (Arrows)
            "${mod}, left, movefocus, l"
            "${mod}, right, movefocus, r"
            "${mod}, up, movefocus, u"
            "${mod}, down, movefocus, d"

            # Move Windows (Shift + Arrows)
            "${mod} SHIFT, left, movewindow, l"
            "${mod} SHIFT, right, movewindow, r"
            "${mod} SHIFT, up, movewindow, u"
            "${mod} SHIFT, down, movewindow, d"
        ] 
        ++ woworkspaces
        ++ moveworkspaces;

        binde = [
            # Resize windows with CTRL + Arrows
            "${mod} CTRL, right, resizeactive, 30 0"
            "${mod} CTRL, left, resizeactive, -30 0"
            "${mod} CTRL, up, resizeactive, 0 -30"
            "${mod} CTRL, down, resizeactive, 0 30"
        ];

        bindm = [
            "${mod}, mouse:272, movewindow"
            "${mod}, mouse:273, resizewindow"
        ];
      };
      extraConfig = ''
        plugin:split-monitor-workspaces:enable_persistent_workspaces = 0
      '';
    };
  };
}