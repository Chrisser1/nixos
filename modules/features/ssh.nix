{ self, ... }: {
  flake.homeModules.ssh = { config, lib, ... }: {
    programs.ssh = {
      enable = true;
      
      matchBlocks = {
        "oracle-server" = {
          hostname = "158.180.42.198";
          user = "root";
          identityFile = "~/.ssh/ssh-key-2025-11-12.key";
          identitiesOnly = true;
        };
      };
    };
  };
}