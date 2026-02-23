{ 
    config, 
    pkgs, 
    lib,
    secrets, 
    ... 
}:
let 
  passwordHash = "$6$fVHOWpCZkfMidTuo$EFKQAqNuBzvUDl4hxACBbZzgYYO18yBw6/u.e8nIjHckpgFqmHRj4qh/UjrxKyH2lzUNQU41FcYaX3T0Jm1j70";
in
{
  programs.fish.enable = true;
  programs.dconf.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
    libX11
    libXext
    libXrender
    libICE
    libSM
    libGL
    glib
    openssl
  ];

  # Github token for private repos
  nix.settings.access-tokens = "github.com=${secrets.githubToken}";
  
  # ZRAM swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50; # ~half of RAM as compressed swap
  };

  # Flakes, store maintenance
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # Locale / time / console
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  console.keyMap = "dk";

  # Networking
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 9001 ];
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.caskaydia-cove
  ];

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Printing
  services.printing.enable = true;

  users.groups.nixos-admins = {};

  # Users
  users.users.chris = {
    isNormalUser = true;
    description = "chris";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" "input" "nixos-admins" ];
    hashedPassword = passwordHash;
    shell =
      if config.home-manager.users.chris.my.shell == "fish"
      then pkgs.fish
      else pkgs.bash;
  };
  users.users.work = {
    isNormalUser = true;
    description = "work";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" "input" "nixos-admins" ];
    hashedPassword = passwordHash;
    shell =
      if config.home-manager.users.work.my.shell == "fish"
      then pkgs.fish
      else pkgs.bash;
  };

  security.sudo.enable = true;
  environment.systemPackages = with pkgs; [
    htop
    home-manager
    gnome-themes-extra
  ];
}
