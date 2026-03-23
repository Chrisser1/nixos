{ self, ... }: {
  flake.homeModules.feature-starship = { config, pkgs, lib, ... }: {
    programs.starship = {
      enable = true;
      
      enableFishIntegration = true; 
      enableBashIntegration = true;
      
      settings = builtins.fromTOML ''
        "$schema" = 'https://starship.rs/config-schema.json'

        format = """
        [](surface0)\
        $os\
        $username\
        [](bg:red fg:surface0)\
        $directory\
        [](fg:red bg:purple)\
        $git_branch\
        $git_status\
        [](fg:purple bg:teal)\
        $c\
        $rust\
        $golang\
        $nodejs\
        $php\
        $java\
        $kotlin\
        $haskell\
        $python\
        [](fg:teal bg:green)\
        $docker_context\
        [](fg:green bg:blue)\
        $time\
        [ ](fg:blue)\
        $line_break$character"""

        palette = 'berserk'

        [palettes.berserk]
        text        = "#EDE6DB"
        subtext1    = "#bac2de"
        subtext0    = "#a6adc8"
        bg0         = "#2B2B2B"
        bg1         = "#1F1F1F"
        bg2         = "#171717"
        red         = "#7F0909"
        orange      = "#B8860B"
        yellow      = "#D4AF37"
        green       = "#6B8E23"
        blue        = "#3E4A89"
        purple      = "#5D1451"
        cyan        = "#4B8E8D"
        white       = "#FFFFFF"
        black       = "#000000"

        overlay2    = "#9399b2"
        overlay1    = "#7f849c"
        overlay0    = "#6c7086"
        surface2    = "#585b70"
        surface1    = "#1F1F1F"
        surface0    = "#2B2B2B"
        peach       = "#B8860B"
        teal        = "#5D1451"
        base        = "#1e1e2e"
        mantle      = "#181825"
        crust       = "#11111b"

        [os]
        disabled = false
        style = "bg:surface0 fg:text"

        [username]
        show_always = true
        style_user = "bg:surface0 fg:text"
        style_root = "bg:surface0 fg:text"
        format = '[ $user ]($style)'

        [directory]
        style = "fg:text bg:red"
        format = "[ $path ]($style)"
        truncation_length = 3
        truncation_symbol = "…/"

        [git_branch]
        symbol = ""
        style = "fg:text bg:teal"
        format = '[[ $symbol $branch ](fg:text bg:purple)]($style)'

        [git_status]
        style = "fg:text bg:teal"
        format = '[[($all_status$ahead_behind )](fg:text bg:purple)]($style)'

        [time]
        disabled    = false
        time_format = "%R"
        style       = "fg:text bg:blue"
        format      = '[[  $time ](fg:text bg:blue)]($style)'

        [line_break]
        disabled = false

        [character]
        disabled = false
        success_symbol = '[](bold fg:green)'
        error_symbol = '[](bold fg:red)'
        vimcmd_symbol = '[](bold fg:green)'
        vimcmd_replace_one_symbol = '[](bold fg:blue)'
        vimcmd_replace_symbol = '[](bold fg:blue)'
        vimcmd_visual_symbol = '[](bold fg:red)'
      '';
    };
  };
}