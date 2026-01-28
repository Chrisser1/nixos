{ pkgs, ... }:
let
  # Define the script
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    #!/usr/bin/env bash
    
    # 1. Define Options using 'printf' for safety
    # We construct the list first so we can pipe it cleanly
    # \x00 = Null Byte (End of text, start of options)
    # \x1f = Unit Separator (End of key, start of value)
    
    entries="Lock\x00icon\x1fsystem-lock-screen\n"
    entries+="Logout\x00icon\x1fsystem-log-out\n"
    entries+="Suspend\x00icon\x1fsystem-suspend\n"
    entries+="Reboot\x00icon\x1fsystem-reboot\n"
    entries+="Shutdown\x00icon\x1fsystem-shutdown\n"
    entries+="Switch User\x00icon\x1fsystem-users\n"
    
    # 2. Pipe to Rofi
    selected=$(printf "$entries" | rofi -dmenu -p "Power Menu" \
                  -theme-str 'window { width: 400px; }' \
                  -theme-str 'listview { lines: 6; }' \
                  -theme-str 'element-icon { size: 48px; }' \
                  -theme-str 'mainbox { children: [ "listview" ]; }')

    # 3. Handle Selection
    case "$selected" in
      "Lock")
        pidof hyprlock || hyprlock
        ;;
      "Logout")
        hyprctl dispatch exit
        ;;
      "Suspend")
        systemctl suspend
        ;;
      "Reboot")
        systemctl reboot
        ;;
      "Shutdown")
        systemctl poweroff
        ;;
      "Switch User")
        ${pkgs.lightdm}/bin/dm-tool switch-to-greeter
        ;;
      *)
        ;;
    esac
  '';
in
{
  home.packages = [
    powermenu
    pkgs.lightdm
  ];
}