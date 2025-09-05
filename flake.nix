{
  description = "My system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		nvf.url = "github:notashelf/nvf";

    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    firefox-addons,
		nvf,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    
    # Import the secrets file here at the top level
    secrets = import ./secrets.nix;

    commonArgs = {
      inherit inputs;
      inherit firefox-addons;
      inherit secrets;
    };
  in {
    # NixOS system configurations
    nixosConfigurations = {
			laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = commonArgs;
        modules = [
          ./hosts/laptop/configuration.nix
					./modules/nixos
					./modules/nixos/dev.nix
					nvf.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            networking.hostName = "laptop";
            
            # Make HM see the same args as your homeConfigurations (esp. `inputs`)
            home-manager.extraSpecialArgs = commonArgs;
            home-manager.useUserPackages = true;
            
            home-manager.users.chris = {
              imports = [
                ./users/chris/home.nix
                ./hosts/laptop/home.nix
              ];
            };
          }
        ];
      };

      pc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = commonArgs;
        modules = [
          ./hosts/pc/configuration.nix
					./modules/nixos
          ./modules/nixos/dev.nix
					nvf.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            networking.hostName = "pc";
            
            home-manager.extraSpecialArgs = commonArgs;
            home-manager.useUserPackages = true;
            
            home-manager.users.chris = {
              imports = [
                ./users/chris/home.nix
                ./hosts/pc/home.nix
              ];
            };
          }
        ];
      };
    };

    # Standalone Home Manager configurations
    homeConfigurations = {
      laptop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = commonArgs;
        modules = [
          ./users/chris/home.nix
          ./hosts/laptop/home.nix
        ];
      };

      pc = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = commonArgs;
        modules = [
          ./users/chris/home.nix
          ./hosts/pc/home.nix
        ];
      };
    };
  };
}
