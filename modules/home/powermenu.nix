{ 
    pkgs, 
    ... 
}:
let
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    #!${pkgs.bash}/bin/bash
    OPTIONS="Logout\nShutdown\nReboot\nLock"
    CHOICE=$(echo -e "$OPTIONS" | wofi --dmenu --prompt "Power Menu")

    case "$CHOICE" in
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
        # You'll need to have hyprlock configured for this to work
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
  ];
}