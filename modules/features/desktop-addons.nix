{ self, ... }: {
  flake.homeModules.feature-desktop-addons = { pkgs, config, lib, ... }: {
    
    # --- Wallpapers ---
    home.file."${config.xdg.configHome}/backgrounds" = {
      source = ../../assets/backgrounds;
      recursive = true;
    };

    services.wpaperd = {
      enable = true;
      settings.default = {
        path = "${config.home.homeDirectory}/.local/state/wpaperd/selected";
        mode = "center";
        sorting = "ascending";
      };
    };

    # --- Screen Lock ---
    programs.hyprlock = {
      enable = true;
      settings = {
        general = { no_fade_in = false; grace = 0; disable_loading_bar = true; };
        background = [{ path = "screenshot"; blur_passes = 3; blur_size = 8; noise = 0.0117; contrast = 0.8916; brightness = 0.8172; vibrancy = 0.1696; vibrancy_darkness = 0.0; }];
        input-field = [{ size = "250, 60"; outline_thickness = 2; dots_size = 0.2; dots_spacing = 0.2; dots_center = true; outer_color = "rgba(136, 8, 8, 1.0)"; inner_color = "rgba(0, 0, 0, 0.5)"; font_color = "rgb(200, 200, 200)"; fade_on_empty = false; font_family = "CaskaydiaCove Nerd Font"; placeholder_text = "<i><span foreground='##cdd6f4'>Input Password...</span></i>"; hide_input = false; position = "0, -120"; halign = "center"; valign = "center"; }];
        label = [{ text = "$TIME"; color = "rgba(255, 255, 255, 0.6)"; font_size = 120; font_family = "CaskaydiaCove Nerd Font"; position = "0, 80"; halign = "center"; valign = "center"; }];
      };
    };

    # --- Screenshots ---
    home.file."${config.xdg.configHome}/satty/config.toml".text = ''
      [general]
      fullscreen = false
      early-exit = false
      initial-tool = "pointer"
      copy-command = "${pkgs.wl-clipboard}/bin/wl-copy"
      annotation-size-factor = 1
      output-filename = "${config.home.homeDirectory}/pictures/screenshots/screenshot-%Y%m%d-%H%M%S.png"
      save-after-copy = false
      default-hide-toolbars = false
      primary-highlighter = "block"
      disable-notifications = false
      [font]
      family = "Work Sans"
      style = "Bold"
    '';
    
    home.packages = with pkgs; [ hyprshot satty ];
    
    wayland.windowManager.hyprland.settings = {
      bind = [
        ", Print, exec, ${lib.getExe pkgs.hyprshot} --mode output --raw | ${lib.getExe pkgs.satty} --filename -"
        "SHIFT, Print, exec, ${lib.getExe pkgs.hyprshot} --mode window --raw | ${lib.getExe pkgs.satty} --filename -"
        "SUPER_SHIFT, s, exec, ${lib.getExe pkgs.hyprshot} --mode region --raw | ${lib.getExe pkgs.satty} --filename -"
      ];
      bindel = [
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%+"
      ];
    };
  };
}