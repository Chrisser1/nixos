{ pkgs, ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
    };
    

    style = ''
      * {
        font-family: "CaskaydiaCove Nerd Font";
        font-size: 14px;
        font-weight: bold;
      }

      #window {
        background-color: #0e0e0e; /* Deep Black */
        color: #cdd6f4;
        border: 2px solid #880808; /* Berserk Red Border */
        border-radius: 0px; /* Sharp corners */
      }

      #input {
        background-color: #1a1a1a;
        color: #ffffff;
        border: 1px solid #880808;
        margin: 10px;
        padding: 10px;
        border-radius: 0px;
      }

      #inner-box {
        margin: 10px;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: #0e0e0e;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }

      #entry:selected {
        background-color: #880808; /* Red selection background */
        color: #ffffff;
        border-radius: 0px;
      }

      #text:selected {
        color: #ffffff;
      }
    '';
  };
}