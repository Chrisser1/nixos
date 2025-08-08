{ 
    config, 
    pkgs, 
    lib, 
    ... 
}:
{
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

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Users
  users.users.chris = {
    isNormalUser = true;
    description = "chris";
    extraGroups = [ "wheel" "networkmanager" "wheel" "docker" ];
  };

  # Optional: explicit, though sudo is enabled by default on NixOS
  security.sudo.enable = true;

  # Unfree (for NVIDIA, Spotify, etc.)
  nixpkgs.config.allowUnfree = true;

  # Keep system packages minimal; GUI apps live in Home-Manager
  environment.systemPackages = with pkgs; [
    htop
    home-manager
  ];
}
