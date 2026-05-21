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
      self.nixosModules.base-system
      self.nixosModules.docker
      
      # System requirements for packages
      self.nixosModules.hyprland
      self.nixosModules.niri
      self.nixosModules.core-packages
      self.nixosModules.fonts
      self.nixosModules.sddm
      self.nixosModules.terminal

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
          
          # For easy connection to servers
          self.homeModules.ssh
          
          # Windows manager and related packages
          self.homeModules.hyprland
          # self.homeModules.waybar

          # Everyday use
          self.homeModules.firefox
          self.homeModules.terminal
          self.homeModules.starship
          self.homeModules.git
          # self.homeModules.rofi
          self.homeModules.nautilus
          self.homeModules.clipboard
          self.homeModules.appearance
          self.homeModules.development
          self.homeModules.search
          self.homeModules.vscode
        ];
        home-manager.users.work.imports = [ 
          self.homeModules.pc-home 

          # Windows manager and related packages
          self.homeModules.hyprland
          # self.homeModules.waybar
          
          # Everyday use
          self.homeModules.firefox
          self.homeModules.terminal
          self.homeModules.starship
          self.homeModules.git
          # self.homeModules.rofi
          self.homeModules.nautilus
          self.homeModules.clipboard
          self.homeModules.appearance
          self.homeModules.development
          self.homeModules.search
          self.homeModules.vscode

          self.homeModules.feature-work-mounts
        ];
      }
    ];
  };
}