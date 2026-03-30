{ self, ... }: {
  flake.nixosModules.pc-configuration = { config, pkgs, inputs, ... }: {
    imports = [
      self.nixosModules.pc-hardware
    ];

    networking.hostName = "pc";
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    system.stateVersion = "25.05";

    # --- NVIDIA ---
    nixpkgs.config.allowUnfree = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = false;
    };

    # Graphics stack
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.nvidia-vaapi-driver ];
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    environment.sessionVariables = {
      USE_WAYLAND_GRIM = "1";
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1"; 
      _JAVA_OPTIONS = "-Dawt.toolkit.name=WLToolkit";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      ADW_DISABLE_PORTAL = "1";
    };

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.devices = [ "nodev" ];
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;

    hardware.enableRedistributableFirmware = true;
    
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;

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