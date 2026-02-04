{ pkgs, ... }: 
{
  home.packages = with pkgs; [
    dbeaver-bin
    jetbrains.datagrip
  ];
}
