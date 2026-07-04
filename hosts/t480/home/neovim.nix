{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    opts = {
      # Numeri di riga
      number = true;
      relativenumber = true;

      # Indentazione
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;

      # Ricerca
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;

      # UI
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      cursorline = true;
      wrap = false;

      # Clipboard
      clipboard = "unnamedplus";

      # Split
      splitbelow = true;
      splitright = true;

      # Performance
      updatetime = 50;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    plugins = {
      # Treesitter — syntax highlighting e indentazione
      treesitter = {
        enable = true;
        settings = {
          indent.enable = true;
          highlight.enable = true;
        };
      };

      # Telescope — fuzzy finder
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>fr" = "oldfiles";
        };
      };

      # Oil — file explorer
      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          delete_to_trash = true;
          view_options.show_hidden = true;
        };
      };
    };

    keymaps = [
      # Navigazione split
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; }

      # Sposta righe in visual mode
      { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; }
      { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; }

      # Mantieni cursore al centro durante scroll
      { mode = "n"; key = "<C-d>"; action = "<C-d>zz"; }
      { mode = "n"; key = "<C-u>"; action = "<C-u>zz"; }

      # Cerca e mantieni al centro
      { mode = "n"; key = "n"; action = "nzzzv"; }
      { mode = "n"; key = "N"; action = "Nzzzv"; }

      # Pulisci highlight ricerca
      { mode = "n"; key = "<Esc>"; action = ":noh<CR>"; }

      # Salva con leader
      { mode = "n"; key = "<leader>w"; action = ":w<CR>"; }
      { mode = "n"; key = "<leader>q"; action = ":q<CR>"; }

      # Oil
      { mode = "n"; key = "-"; action = "<CMD>Oil<CR>"; options.desc = "Open parent directory"; }
    ];

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
  };
}
