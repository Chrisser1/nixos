{ self, ... }: {
  flake.homeModules.pc-home = { config, pkgs, inputs, ... }: {
    home.stateVersion = "25.05";
    
    wayland.windowManager.hyprland.settings = {
      monitor = [
        # Middle monitor (ASUS)
        "DP-4,highrr,0x0,1"
        
        # Left monitor (HP)
        "HDMI-A-1,highrr,auto-left,1"
        
        # Right monitor (HP)
        "HDMI-A-2,highrr,auto-right,1" 
      ];
    };
  };
}