{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
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
        # your original Berserk colors
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

        # aliases so your format’s surface0, peach, teal, etc. still work
        overlay2    = "#9399b2"
        overlay1    = "#7f849c"
        overlay0    = "#6c7086"
        surface2    = "#585b70"
        surface1    = "#1F1F1F"  # == bg1 (if you need it)
        surface0    = "#2B2B2B"  # == bg0
        peach       = "#B8860B"  # == orange
        teal        = "#5D1451"  # == Purple
        base        = "#1e1e2e"
        mantle      = "#181825"
        crust       = "#11111b"

        [palettes.gruvbox_dark]
        color_fg0 = '#fbf1c7'
        color_bg1 = '#3c3836'
        color_bg3 = '#665c54'
        color_blue = '#458588'
        color_aqua = '#689d6a'
        color_green = '#98971a'
        color_orange = '#d65d0e'
        color_purple = '#b16286'
        color_red = '#cc241d'
        color_yellow = '#d79921'

        [palettes.catppuccin_mocha]
        rosewater = "#f5e0dc"
        flamingo = "#f2cdcd"
        pink = "#f5c2e7"
        orange = "#cba6f7"
        red = "#f38ba8"
        maroon = "#eba0ac"
        peach = "#fab387"
        yellow = "#f9e2af"
        green = "#a6e3a1"
        teal = "#94e2d5"
        sky = "#89dceb"
        sapphire = "#74c7ec"
        blue = "#89b4fa"
        lavender = "#b4befe"
        text = "#cdd6f4"
        subtext1 = "#bac2de"
        subtext0 = "#a6adc8"
        overlay2 = "#9399b2"
        overlay1 = "#7f849c"
        overlay0 = "#6c7086"
        surface2 = "#585b70"
        surface1 = "#45475a"
        surface0 = "#313244"
        base = "#1e1e2e"
        mantle = "#181825"
        crust = "#11111b"

        [os]
        disabled = false
        style = "bg:surface0 fg:text"

        [os.symbols]
        Windows = "󰍲"
        Ubuntu = "󰕈"
        SUSE = ""
        Raspbian = "󰐿"
        Mint = "󰣭"
        Macos = ""
        Manjaro = ""
        Linux = "󰌽"
        Gentoo = "󰣨"
        Fedora = "󰣛"
        Alpine = ""
        Amazon = ""
        Android = ""
        Arch = "󰣇"
        Artix = "󰣇"
        CentOS = ""
        Debian = "󰣚"
        Redhat = "󱄛"
        RedHatEnterprise = "󱄛"

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

        [directory.substitutions]
        "Documents" = "󰈙 "
        "Downloads" = " "
        "Music" = "󰝚 "
        "Pictures" = " "
        "Developer" = "󰲋 "

        [git_branch]
        symbol = ""
        style = "fg:text bg:teal"
        format = '[[ $symbol $branch ](fg:text bg:purple)]($style)'

        [git_status]
        style = "fg:text bg:teal"
        format = '[[($all_status$ahead_behind )](fg:text bg:purple)]($style)'

        [nodejs]
        symbol = ""
        style = "fg:text bg:teal"
        format = '[[ $symbol( $version) ](fg:text bg:teal)]($style)'

        [c]
        symbol = " "
        style = "fg:text bg:teal"
        format = '[[ $symbol( $version) ](fg:text bg:teal)]($style)'

        [rust]
        symbol = ""
        style = "fg:text bg:teal"
        format = '[[ $symbol( $version) ](fg:text bg:teal)]($style)'

        [golang]
        symbol = ""
        style = "fg:text bg:teal"
        format = '[[ $symbol( $version) ](fg:text bg:teal)]($style)'

        [php]
        symbol = ""
        style = "fg:text bg:teal"
        format = '[[ $symbol( $version) ](fg:text bg:teal)]($style)'

        [java]
        symbol = " "
        style = "fg:text bg:teal"
        format = '[[ $symbol( $version) ](fg:text bg:teal)]($style)'

        [kotlin]
        symbol = ""
        style = "fg:text bg:teal"
        format = '[[ $symbol( $version) ](fg:text bg:teal)]($style)'

        [haskell]
        symbol = ""
        style = "fg:text bg:teal"
        format = '[[ $symbol( $version) ](fg:text bg:teal)]($style)'

        [python]
        symbol = ""
        style = "fg:text bg:teal"
        format = '[[ $symbol( $version) ](fg:text bg:teal)]($style)'

        [docker_context]
        symbol = ""
        style = "bg:mantle"
        format = '[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)'

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
}
