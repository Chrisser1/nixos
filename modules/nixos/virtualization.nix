{ config, pkgs, ... }:

{
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