{
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 300;
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
    };
    style = ''
      * {
        font: "Fira Code 12";
      }

      #window {
        background-color: #282a36;
        color: #f8f8f2;
        border-radius: 10px;
      }

      #input {
        background-color: #44475a;
        color: #f8f8f2;
        border: none;
        padding: 8px;
      }

      #entry:selected {
        background-color: #44475a;
      }

      #text:selected {
        color: #f8f8f2;
      }
    '';
  };
}
