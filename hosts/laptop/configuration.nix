{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: 
{
  networking.hostName = "laptop";
  system.stateVersion = "25.05";

  imports = [
    ./hardware-configuration.nix
  ];

  # # --- NVIDIA (safe defaults for Hyprland) ---
  # # Requires: nixpkgs.config.allowUnfree = true (in your base).
  # services.xserver.videoDrivers = [ "nvidia" ]; # loads the kernel module
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   open = true;                           # open kernel module (Ada supported)
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  #   powerManagement.enable = false;        # leave off on desktops/VM passthrough; flip on if needed
  # };
  
  environment.sessionVariables = {
    USE_WAYLAND_GRIM = "1";
    NIXOS_OZONE_WL = "1"; # required per nixos wiki page on VS Code
    _JAVA_AWT_WM_NONREPARENTING = "1"; 
    _JAVA_OPTIONS = "-Dawt.toolkit.name=WLToolkit"; # Important for JetBrains IDEs
    # # NVIDIA + wlroots helpers (uncomment/tweak if needed)
    # LIBVA_DRIVER_NAME = "nvidia";     # with nvidia-vaapi-driver
    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # # WLR_NO_HARDWARE_CURSORS = "1";  # only if you see cursor glitches
  };

  # Bootloader
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  # # Bootloader (VM example)
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/vda";

  # configuration.nix or your host module
  hardware.bluetooth.enable = true;
  # optional GUI:
  services.blueman.enable = true;

  # For virtualbox
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "chris" ];
  environment.etc."vbox/networks.conf".text = ''
    * 192.168.0.0/16
  '';
  # Prevent KVM from loading to allow VirtualBox to use hardware virtualization
  boot.blacklistedKernelModules = [ "kvm_intel" "kvm" ];
}
