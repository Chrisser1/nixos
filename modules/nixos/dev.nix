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

  ##### NVF (Neovim config)
  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings = {
      vim = {
        startPlugins = with pkgs.vimPlugins; [
          nvim-comment
          multicursor-nvim
        ];

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

        globals = {
          mapleader = " ";
        };

        keymaps = [
          # --- Multi-Cursor (doesn't currently work needs to be fixed) ---
          {
            mode = [ "n" "v" ];
            key = "<C-A-Down>";
            action = ":lua require('multicursor-nvim').lineAddCursor(1)<CR>";
            desc = "Multi-Cursor: Add cursor below";
          }
          {
            mode = [ "n" "v" ];
            key = "<C-A-Up>";
            action = ":lua require('multicursor-nvim').lineAddCursor(-1)<CR>";
            desc = "Multi-Cursor: Add cursor above";
          }
          {
            mode = [ "n" "v" ];
            key = "<C-d>";
            action = ":lua require('multicursor-nvim').matchAddCursor(1)<CR>";
            desc = "Multi-Cursor: Select next match";
          }

          # --- Select with Shift + Arrow ---
          # Normal Mode
          { mode = "n"; key = "<S-Up>";    action = "v<Up>";    desc = "Select line up"; }
          { mode = "n"; key = "<S-Down>";  action = "v<Down>";  desc = "Select line down"; }
          { mode = "n"; key = "<S-Left>";  action = "v<Left>";  desc = "Select left"; }
          { mode = "n"; key = "<S-Right>"; action = "v<Right>"; desc = "Select right"; }

          # Insert Mode
          { mode = "i"; key = "<S-Up>";    action = "<Esc>v<Up>";    desc = "Select line up"; }
          { mode = "i"; key = "<S-Down>";  action = "<Esc>v<Down>";  desc = "Select line down"; }
          { mode = "i"; key = "<S-Left>";  action = "<Esc>v<Left>";  desc = "Select left"; }
          { mode = "i"; key = "<S-Right>"; action = "<Esc>v<Right>"; desc = "Select right"; }

          # Visual Mode
          { mode = "v"; key = "<S-Up>";    action = "<Up>";    desc = "Select line up"; }
          { mode = "v"; key = "<S-Down>";  action = "<Down>";  desc = "Select line down"; }
          { mode = "v"; key = "<S-Left>";  action = "<Left>";  desc = "Select left"; }
          { mode = "v"; key = "<S-Right>"; action = "<Right>"; desc = "Select right"; }

          # --- Copy Line Up/Down ---
          {
            mode = "n";
            key = "<A-S-Down>";
            action = "yyp"; # Yank line and paste below
            desc = "Copy line down";
          }
          {
            mode = "v";
            key = "<A-S-Down>";
            action = "y'>p"; # Yank selection and paste below
            desc = "Copy selection down";
          }
          {
            mode = "n";
            key = "<A-S-Up>";
            action = "Yp"; # Yank line and paste above
            desc = "Copy line up";
          }
          {
            mode = "v";
            key = "<A-S-Up>";
            action = "y'<P"; # Yank selection and paste above
            desc = "Copy selection up";
          }

          # --- Move Line Up/Down ---
          {
            mode = "n";
            key = "<A-Down>";
            action = "<cmd>m .+1<cr>==";
            desc = "Move line down";
          }
          {
            mode = "v";
            key = "<A-Down>";
            action = ":m '>+1<cr>gv=gv";
            desc = "Move selection down";
          }
          {
            mode = "n";
            key = "<A-Up>";
            action = "<cmd>m .-2<cr>==";
            desc = "Move line up";
          }
          {
            mode = "v";
            key = "<A-Up>";
            action = ":m '<-2<cr>gv=gv";
            desc = "Move selection up";
          }
          
          # --- Other Mappings ---
          {
            mode = "n";
            key = "<C-/>";
            action = "gcc";
            desc = "Comment: Toggle line";
          }
          {
            mode = "v";
            key = "<C-/>";
            action = "gc";
            desc = "Comment: Toggle selection";
          }
          {
            mode = "n";
            key = "<leader>ff";
            action = "<cmd>Telescope find_files<cr>";
            desc = "Telescope: Find Files";
          }
          {
            mode = "n";
            key = "<leader>fg";
            action = "<cmd>Telescope live_grep<cr>";
            desc = "Telescope: Live Grep";
          }
          {
            mode = "n";
            key = "<leader>fb";
            action = "<cmd>Telescope buffers<cr>";
            desc = "Telescope: Find Buffers";
          }
        ];
      };
    };
  };
}