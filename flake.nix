{
  description = "My system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nix-vscode-extensions.overlays.default
      ];
    };
    
    secrets = import "/home/chris/nixos/secrets.nix";

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

            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
            ];
            
            # Make HM see the same args as your homeConfigurations (esp. `inputs`)
            home-manager.extraSpecialArgs = commonArgs;
            home-manager.useUserPackages = true;

            home-manager.useGlobalPkgs = true;
            
            home-manager.users.chris = {
              imports = [
                ./users/chris/home.nix
                ./hosts/laptop/home.nix
              ];
            };
            home-manager.users.work = {
              imports = [
                ./users/work/home.nix
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

            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
            ];
            
            home-manager.extraSpecialArgs = commonArgs;
            home-manager.useUserPackages = true;

            home-manager.useGlobalPkgs = true;
            
            home-manager.users.chris = {
              imports = [
                ./users/chris/home.nix
                ./hosts/pc/home.nix
              ];
            };
            home-manager.users.work = {
              imports = [
                ./users/work/home.nix
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
      laptop_work = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = commonArgs;
        modules = [
          ./users/work/home.nix
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
      pc_work = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = commonArgs;
        modules = [
          ./users/work/home.nix
          ./hosts/pc/home.nix
        ];
      };
    };
  };
}
