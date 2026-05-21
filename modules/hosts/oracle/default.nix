{ self, inputs, ... }: 
let
  system = "aarch64-linux";
  commonArgs = { inherit inputs; secrets = import "/home/chris/nixos/secrets.nix"; };
in {
  flake.nixosConfigurations.oracle = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = commonArgs;
    modules = [
      self.nixosModules.oracle-configuration
      self.nixosModules.base-system
      
      # Kubernetes Features
      self.nixosModules.kubernetes-server
      self.nixosModules.kubernetes-deployments
    ];
  };
}