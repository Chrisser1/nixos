{ self, ... }: {
  flake.nixosModules.oracle-configuration = { config, pkgs, ... }: {
    imports = [ ./hardware.nix ];

    networking.hostName = "oracle";
    system.stateVersion = "25.05";

    # Ensure SSH is running and strictly allows your key
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };
  };
}