{ self, ... }: {
  flake.homeModules.pc-home = { config, pkgs, inputs, ... }: {
    home.stateVersion = "25.05";
    
    wayland.windowManager.hyprland.settings = {
      monitor = [
        # Left monitor (HP) - Locked at X:0
        "HDMI-A-2,highrr,0x0,1"
        
        # Middle monitor (ASUS) - Locked at X:1920
        "DP-1,highrr,1920x0,1"
        
        # Right monitor (HP) - Locked at X:4480
        "HDMI-A-1,highrr,4480x0,1" 
      ];
    };
  };
}