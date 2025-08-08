{ 
    config, 
    pkgs, 
    lib, 
    ... 
}:
{
  ##### Docker (rootless) – enable only if you use it
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  # (group membership isn’t required for rootless, but having "docker" in
  # extraGroups doesn't hurt and you already have it in base.nix.)

  ##### NVF (Neovim config)
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        visuals.nvim-cursorline = {
          enable = true;
          setupOpts.cursorline = {
            enable = true;
            highlight = "CursorLine";
            timeout = 0;
          };
        };

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        lsp.enable = true;

        languages = {
          enableTreesitter = true;
          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
        };

        options = {
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
        };
      };
    };
  };
}
