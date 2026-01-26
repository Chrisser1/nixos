{ 
  pkgs, 
  ... 
}:
let
  powerMenuPkgs = pkgs.lightdm;
  
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    #!${pkgs.bash}/bin/bash
    OPTIONS="Switch User\nLogout\nShutdown\nReboot\nLock"
    CHOICE=$(echo -e "$OPTIONS" | wofi --dmenu --prompt "Power Menu")

    case "$CHOICE" in
      "Switch User")
        ${powerMenuPkgs}/bin/dm-tool switch-to-greeter
        ;;
      Logout)
        hyprctl dispatch exit
        ;;
      Shutdown)
        shutdown now
        ;;
      Reboot)
        reboot
        ;;
      Lock)
        hyprlock
        ;;
      *)
        ;;
    esac
  '';
in
{
  home.packages = [
    powermenu
    powerMenuPkgs
  ];
}