{ pkgs, config, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;
    
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      mkhl.direnv
    ];
  };

  home.file.".config/Code/User/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/modules/home/dev/vscode-settings.json";
  };

  # This does the same for your keybindings.
  home.file.".config/Code/User/keybindings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/modules/home/dev/vscode-keybindings.json";
  };
}