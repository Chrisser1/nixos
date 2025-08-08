{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
		./packages.nix
    # ./alacritty.nix
    ./kitty.nix
    ./starship.nix
    ./bash.nix
    ./hyprland.nix
    ./waybar.nix
    ./git.nix
    ./vscode.nix
#    ./nixvim.nix
    ./hyprshot.nix
    ./wofi.nix
    ./wpaperd.nix
  ];
}
