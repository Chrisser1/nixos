{
    pkgs,
    inputs,
    lib,
    ...
}:
let
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
      embeddedTheme = "pixel_sakura";
  };
in
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      enableHidpi = true;
      package = pkgs.kdePackages.sddm;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        custom-sddm-astronaut
        kdePackages.qtsvg
        kdePackages.qtvirtualkeyboard
        kdePackages.qtmultimedia
      ];
    };
    defaultSession = "hyprland";
  };

  environment.systemPackages = [
    custom-sddm-astronaut
  ];

  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
};
}