{ self, ... }: 
let 
    vars = import ./kubernetes/cluster-vars.nix;
in {
  flake.homeModules.ssh = { config, lib, ... }: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {};

        "${vars.controlPlaneSshAlias}" = {
          HostName = vars.controlPlaneIp;
          User = vars.controlPlaneSshUser;
          IdentityFile = vars.controlPlaneSshKey;
          IdentitiesOnly = "yes";
        };
      };
    };
  };
}