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

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    USE_WAYLAND_GRIM = "1";
    NIXOS_OZONE_WL = "1"; # required per nixos wiki page on VS Code
    _JAVA_AWT_WM_NONREPARENTING = "1"; 
    _JAVA_OPTIONS = "-Dawt.toolkit.name=WLToolkit"; # Important for JetBrains IDEs
    ADW_DISABLE_PORTAL = "1";
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
}
