{
  config,
  pkgs,
  inputs,
  ...
}: 
{
  networking.hostName = "laptop";
  system.stateVersion = "25.05";

  imports = [
    ./hardware-configuration.nix
  ];

  # --- NVIDIA (safe defaults for Hyprland) ---
  # Requires: nixpkgs.config.allowUnfree = true (in your base).
  services.xserver.videoDrivers = [ "nvidia" ]; # loads the kernel module
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;                           # open kernel module (Ada supported)
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = false;        # leave off on desktops/VM passthrough; flip on if needed
  };
  
  environment.sessionVariables = {
    USE_WAYLAND_GRIM = "1";
    # NVIDIA + wlroots helpers (uncomment/tweak if needed)
    LIBVA_DRIVER_NAME = "nvidia";     # with nvidia-vaapi-driver
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # WLR_NO_HARDWARE_CURSORS = "1";  # only if you see cursor glitches
  };

  # Bootloader
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Bootloader (VM example)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
}
