{ pkgs, lib, ... }:
{
  systemd.user.services = lib.mkForce {
    cliphist = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Unit = {
        Description = "Clipboard history \"manager\" for wayland";
        Documentation = [ "https://github.com/sentriz/cliphist" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${pkgs.wl-clipboard-rs}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist -max-items 10 store";
        ExecCondition = "${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition \"Hyprland\" \"\" ";
        Restart = "on-failure";
        Slice = "app-graphical.slice";
      };
    };
  };
}