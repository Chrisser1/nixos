{ self, ... }: {
  flake.nixosModules.laptop-configuration = { config, pkgs, inputs, lib, ... }: {
    networking.hostName = "laptop";
    system.stateVersion = "25.05";

    imports = [
      self.nixosModules.laptop-hardware
    ];

    nixpkgs.config.allowUnfree = true;

    environment.sessionVariables = {
      USE_WAYLAND_GRIM = "1";
      NIXOS_OZONE_WL = "1"; 
      _JAVA_AWT_WM_NONREPARENTING = "1"; 
      _JAVA_OPTIONS = "-Dawt.toolkit.name=WLToolkit"; 
      ADW_DISABLE_PORTAL = "1";
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; 
      dedicatedServer.openFirewall = true; 
      localNetworkGameTransfers.openFirewall = true; 
    };

    # Bootloader
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      gfxmodeEfi = "1920x1080";
      fontSize = 24;
    };
    boot.kernelParams = [ "video=1024x768" ];

    # optional GUI:
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    programs.fish.enable = true;

    # User config
    users.users.chris = let 
      passwordHash = "$6$fVHOWpCZkfMidTuo$EFKQAqNuBzvUDl4hxACBbZzgYYO18yBw6/u.e8nIjHckpgFqmHRj4qh/UjrxKyH2lzUNQU41FcYaX3T0Jm1j70";
    in {
      isNormalUser = true;
      description = "Chris";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
      shell = pkgs.fish;
      hashedPassword = passwordHash;
    };

    users.users.work = let 
      passwordHash = "$6$fVHOWpCZkfMidTuo$EFKQAqNuBzvUDl4hxACBbZzgYYO18yBw6/u.e8nIjHckpgFqmHRj4qh/UjrxKyH2lzUNQU41FcYaX3T0Jm1j70";
    in {
      isNormalUser = true;
      description = "Work";
      extraGroups = [ "networkmanager" "video" "audio" ];
      shell = pkgs.fish;
      hashedPassword = passwordHash;
    };
  };
}