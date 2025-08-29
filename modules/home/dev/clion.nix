{ 
    config, 
    pkgs, 
    lib, 
    ... 
}:
let
  # Use lib.mkOption to create a new setting we can configure per-host.
  cfg = config.wayland.clion;
in
{
  options.wayland.clion = {
    enable = lib.mkEnableOption "Enable the CLion Wayland wrapper";

    scale = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "The UI scale factor for CLion, to match Hyprland's monitor setting.";
    };
  };

  # This block only runs if you set `wayland.clion.enable = true;` in your host config.
  config = lib.mkIf cfg.enable {

    home.packages = [
      (pkgs.writers.writeShellScriptBin "clion" ''
        #!/usr/bin/env bash
        # Fixes pop-up menus, context menus, and window placement.
        export _JAVA_AWT_WM_NONREPARENTING=1
        
        # Fixes UI scaling and mouse pointer misalignment by using the
        # scale factor we pass in from our host-specific config.
        export _JAVA_OPTIONS="-Dsun.java2d.uiScale=${toString cfg.scale}"
        
        # Launch the actual CLion executable, passing along any arguments.
        exec ${pkgs.jetbrains.clion}/bin/clion "$@"
      '')
    ];

  };
}
