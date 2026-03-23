{ self, ... }: {
  flake.nixosModules.feature-docker = { pkgs, ... }: {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
    users.extraGroups.docker.members = [ "chris" "work" ];
  };
}