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
        
        # 1. Enable fish system-wide
        self.nixosModules.cli 

        # 2. Inject Home Manager for the root user
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          home-manager.users.root.imports = [
            self.homeModules.cli
            self.homeModules.shell-aliases
          ];
        }
    
    #   # Kubernetes Features
    #   self.nixosModules.kubernetes-server
    #   self.nixosModules.kubernetes-deployments
        ];
    };
}