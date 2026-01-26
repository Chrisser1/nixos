{ pkgs, ... }:
{
  # Better 'ls'
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    extraOptions = [ "--icons" "--group-directories-first" ];
  };

  # Better 'cd'
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };
  
  # Better 'cat'
  programs.bat = {
    enable = true;
    config.theme = "Dracula"; 
  };
}