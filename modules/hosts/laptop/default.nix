{
  self,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  commonArgs = {
    inherit inputs;
    firefox-addons = inputs.firefox-addons;
    secrets = import "/home/chris/nixos/secrets.nix";
  };
in {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = commonArgs;
    modules = [
      self.nixosModules.laptop-configuration
      self.nixosModules.base-system
      self.nixosModules.desktop
      self.nixosModules.users
      self.nixosModules.docker

      # System requirements for packages
      self.nixosModules.hyprland
      self.nixosModules.niri
      self.nixosModules.core-packages
      self.nixosModules.vesktop
      self.nixosModules.noise-cancellation
      self.nixosModules.fonts
      self.nixosModules.sddm
      self.nixosModules.cli

      # Include your external flake modules
      inputs.nvf.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [inputs.nix-vscode-extensions.overlays.default];
        home-manager.extraSpecialArgs = commonArgs;
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;

        home-manager.users.chris.imports = [
          self.homeModules.laptop-home
          self.homeModules.profile-chris
        ];
        home-manager.users.work.imports = [
          self.homeModules.laptop-home
          self.homeModules.profile-work
        ];
      }
    ];
  };
}
