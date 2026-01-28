{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };

    # The Berserk Theme
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color = mkLiteral "#171717"; # Berserk bg
        text-color = mkLiteral "#EDE6DB";       # Berserk text
        border-color = mkLiteral "#7F0909";     # Berserk red
      };
      
      "#window" = {
        width = mkLiteral "600px";
        border = mkLiteral "2px";
        padding = mkLiteral "10px";
        border-radius = mkLiteral "0px";
        background-color = mkLiteral "#171717";
      };

      "#mainbox" = {
        background-color = mkLiteral "transparent";
        children = map mkLiteral [ "inputbar" "listview" ];
      };

      "#inputbar" = {
        children = map mkLiteral [ "prompt" "entry" ];
        background-color = mkLiteral "#2B2B2B";
        padding = mkLiteral "10px";
        border = mkLiteral "1px";
        border-radius = mkLiteral "0px";
        margin = mkLiteral "0px 0px 10px 0px";
      };

      "#entry" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "#EDE6DB";
      };

      "#prompt" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "#EDE6DB";
        padding = mkLiteral "0px 10px 0px 0px";
      };

      "#listview" = {
        background-color = mkLiteral "transparent";
        lines = 8;
        columns = 1;
      };

      "#element" = {
        padding = mkLiteral "8px";
        text-color = mkLiteral "#EDE6DB";
        background-color = mkLiteral "transparent";
      };

      "#element selected" = {
        background-color = mkLiteral "#7F0909"; # Red highlight
        text-color = mkLiteral "#FFFFFF";
      };

      "#element-icon" = {
        size = mkLiteral "24px";
        padding = mkLiteral "0 10px 0 0";
        background-color = mkLiteral "transparent";
      };
      
      "#element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };
    };
  };
}