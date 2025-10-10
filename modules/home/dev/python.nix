# modules/home/dev/python.nix
{ 
    pkgs, 
    config, 
    ... 
    }:
{
    # conda-compatible, fast, perfect on NixOS
    home.packages = [ pkgs.micromamba ];

    # where envs live (per-user, no sudo)
    home.sessionVariables.MAMBA_ROOT_PREFIX =
        "${config.home.homeDirectory}/.mamba";

    # sane defaults
    home.file.".condarc".text = ''
        channels:
        - conda-forge
        channel_priority: strict
    '';

    # optional convenience
    programs.bash.shellAliases = {
        conda = "micromamba";   # muscle memory
    };
}
