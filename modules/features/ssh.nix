{ self, ... }: {
  flake.homeModules.ssh = { config, lib, ... }: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {};

        "oracle-server" = {
          HostName = "158.180.42.198";
          User = "root";
          IdentityFile = "~/.ssh/ssh-key-2025-11-12.key";
          IdentitiesOnly = "yes";
        };
      };
    };
  };
}