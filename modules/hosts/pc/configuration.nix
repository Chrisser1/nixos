{self, ...}: {
  flake.nixosModules.pc-configuration = {
    config,
    pkgs,
    inputs,
    ...
  }: {
    imports = [
      self.nixosModules.pc-hardware
    ];

    networking.hostName = "pc";
    system.stateVersion = "25.05";

    # --- NVIDIA ---
    services.xserver.videoDrivers = ["nvidia"];
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
      extraPackages = [pkgs.nvidia-vaapi-driver];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    boot.kernelParams = [
      "usbcore.autosuspend=-1"
      "nvidia-drm.fbdev=1"
    ];

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.devices = ["nodev"];
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;
  };
}
