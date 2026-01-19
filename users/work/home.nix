{ 
    pkgs, 
    ... 
}:
{
  imports = [
    ../common.nix
    ../../modules/home/dev/go.nix
  ];

  home = {
    username = "work";
    homeDirectory = "/home/work";
  };

  my.shell = "fish";

  home.packages = with pkgs; [
    tailscale
    dconf

    rclone
    fuse3
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    # We can just list our mount points here
    extraConfig = {
      XDG_SHAREPOINT_TEAM_DIR = "$HOME/WavepistonTeamFolder";
      XDG_SHAREPOINT_DATA_DIR = "$HOME/WavepistonDataWarehouse";
    };
  };

  systemd.user.services = {
    WavepistonTeamFolder-mount = {
      Unit = {
        Description = "Mount Wavepiston Team Folder";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.rclone}/bin/rclone mount WavepistonTeamFolder: %h/WavepistonTeamFolder --vfs-cache-mode writes";
        ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/WavepistonTeamFolder";
        Restart = "on-failure";
      };
    };

    WavepistonDataWarehouse-mount = {
      Unit = {
        Description = "Mount Wavepiston DataWarehouse";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.rclone}/bin/rclone mount WavepistonDataWarehouse: %h/WavepistonDataWarehouse --vfs-cache-mode writes";
        ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/WavepistonDataWarehouse";
        Restart = "on-failure";
      };
    };
  };
}