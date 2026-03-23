{ self, inputs, ... }: 
let
  system = "x86_64-linux";
  commonArgs = {
    inherit inputs;
    firefox-addons = inputs.firefox-addons;
    secrets = import "/home/chris/nixos/secrets.nix";
  };
in {
  flake.nixosConfigurations.pc = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = commonArgs;
    modules = [
      self.nixosModules.pc-configuration
      self.nixosModules.feature-base-system
      self.nixosModules.feature-docker
      
      # System requirements for packages
      self.nixosModules.feature-hyprland
      self.nixosModules.feature-niri
      self.nixosModules.feature-core-packages
      self.nixosModules.feature-fonts
      self.nixosModules.feature-sddm

      # Include your external flake modules
      inputs.nvf.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      
      {
        nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];
        home-manager.extraSpecialArgs = commonArgs;
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        
        # User settings
        home-manager.users.chris.imports = [ 
          self.homeModules.pc-home 
          
          # Windows manager and related packages
          self.homeModules.feature-hyprland
          self.homeModules.feature-waybar

          # Everyday use
          self.homeModules.feature-firefox
          self.homeModules.feature-terminal
          self.homeModules.feature-starship
          self.homeModules.feature-git
          self.homeModules.feature-rofi
          self.homeModules.feature-desktop-addons
          self.homeModules.feature-nautilus
          self.homeModules.feature-clipboard
          self.homeModules.feature-appearance
          self.homeModules.feature-development
          self.homeModules.feature-search
          self.homeModules.feature-vscode
        ];
        home-manager.users.work.imports = [ 
          self.homeModules.pc-home 

          # Windows manager and related packages
          self.homeModules.feature-hyprland
          self.homeModules.feature-waybar
          
          # Everyday use
          self.homeModules.feature-firefox
          self.homeModules.feature-terminal
          self.homeModules.feature-starship
          self.homeModules.feature-git
          self.homeModules.feature-rofi
          self.homeModules.feature-desktop-addons
          self.homeModules.feature-nautilus
          self.homeModules.feature-clipboard
          self.homeModules.feature-appearance
          self.homeModules.feature-development
          self.homeModules.feature-search
          self.homeModules.feature-vscode

          self.homeModules.feature-work-mounts
        ];
      }
    ];
  };
}