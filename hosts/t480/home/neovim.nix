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

      # LSP
      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;        # TypeScript/JavaScript
          pyright.enable = true;      # Python
          html.enable = true;         # HTML
          cssls.enable = true;        # CSS
        };
      };

      # Autocompletamento
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };

      # Sorgente LSP per cmp
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;

      # Autopairs — chiude automaticamente parentesi, virgolette, ecc.
      nvim-autopairs.enable = true;

      # Commenti — gcc per commentare una riga, gc in visual mode
      comment.enable = true;

      # Statusline minimale
      lualine = {
        enable = true;
        settings.options = {
        theme = "auto";
        component_separators = { left = ""; right = ""; };
        section_separators = { left = ""; right = ""; };
        };
      };

      # Git segni a sinistra — mostra modifiche rispetto al repo
      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "▎";
          change.text = "▎";
          delete.text = "";
          topdelete.text = "";
          changedelete.text = "▎";
        };
      };

      # Indent lines — mostra le linee di indentazione
      indent-blankline.enable = true;

      # Which-key — mostra i keybind disponibili dopo leader
      which-key.enable = true;
      
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

      # Leader
      { mode = [ "n" "v" ]; key = "<Space>"; action = "<Nop>"; options.silent = true; }
      { mode = "n"; key = "<leader>w"; action = ":w<CR>"; }
      { mode = "n"; key = "<leader>q"; action = ":q<CR>"; }

      # Oil
      { mode = "n"; key = "-"; action = "<CMD>Oil<CR>"; options.desc = "Open parent directory"; }

      # LSP
      { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<CR>"; options.desc = "Go to definition"; }
      { mode = "n"; key = "gr"; action = "<cmd>lua vim.lsp.buf.references()<CR>"; options.desc = "Go to references"; }
      { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<CR>"; options.desc = "Hover docs"; }
      { mode = "n"; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>"; options.desc = "Code action"; }
      { mode = "n"; key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<CR>"; options.desc = "Rename"; }
      { mode = "n"; key = "<leader>e"; action = "<cmd>lua vim.diagnostic.open_float()<CR>"; options.desc = "Show error"; }
      { mode = "n"; key = "[d"; action = "<cmd>lua vim.diagnostic.goto_prev()<CR>"; options.desc = "Prev diagnostic"; }
      { mode = "n"; key = "]d"; action = "<cmd>lua vim.diagnostic.goto_next()<CR>"; options.desc = "Next diagnostic"; }
    ];

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
  };
}
