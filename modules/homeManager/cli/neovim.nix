{
  pkgs,
  lib,
  config,
  ...
}:
let
in
# remove next time vimPlugins is regenerated. We need v0.6
# crates-nvim-custom = pkgs.vimUtils.buildVimPlugin {
#   pname = "crates.nvim";
#   version = "2025-02-19";
#   src = pkgs.fetchFromGitHub {
#     owner = "saecki";
#     repo = "crates.nvim";
#     rev = "1803c8b5516610ba7cdb759a4472a78414ee6cd4";
#     sha256 = "sha256-xuRth8gfX6ZTV3AUBaTM9VJr7ulsNFxtKEsFDZduDC8=";
#   };
#   dependencies = with pkgs.vimPlugins; [ plenary-nvim ];
#   checkInputs = with pkgs.vimPlugins; [ none-ls-nvim ];
#   meta.homepage = "https://github.com/saecki/crates.nvim/";
#   meta.hydraPlatforms = [ ];
# };
{
  options = {
    neovim.enable = lib.mkEnableOption "enables neovim";
  };

  config = lib.mkIf config.neovim.enable {
    home.shellAliases = {
      n = "nvim";
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      withPython3 = true;
      withNodeJs = true;
      plugins = with pkgs.vimPlugins; [
        lazy-nvim

        # Completion
        blink-cmp

        # Editing tools
        nvim-autopairs
        nvim-ts-autotag
        comment-nvim

        # Language Server Protocol
        nvim-lspconfig
        fidget-nvim

        # Language specific tooling
        rustaceanvim
        crates-nvim
        lazydev-nvim
        typescript-tools-nvim

        # Testing
        neotest

        # Debug Adapter Protocol
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-dap-go

        # Misc.
        snacks-nvim
        plenary-nvim
        nvim-nio
        FixCursorHold-nvim

        # Formatting
        conform-nvim

        # Treesitter
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
        nvim-treesitter-context

        # UI
        catppuccin-nvim
        lualine-nvim
        gitsigns-nvim
        noice-nvim
        nui-nvim
        nvim-notify
        nvim-tree-lua
        vim-kitty-navigator
      ];
      extraPackages = with pkgs; [
        astro-language-server
        bash-language-server
        beautysh
        clang-tools
        csharpier
        dockerfile-language-server-nodejs
        eslint
        fzf
        gopls
        lua-language-server
        nixd
        nixfmt-rfc-style
        nodePackages.prettier
        ocamlformat
        rust-analyzer
        rustywind
        shfmt
        stylua
        yaml-language-server
        vscode-extensions.vadimcn.vscode-lldb
        vscode-langservers-extracted
        zls
      ];

      # Add this back if dotnet dev is necessary
      # vim.g.omnisharp_path = '${pkgs.omnisharp-roslyn}/bin/OmniSharp'
      extraLuaConfig = ''
        vim.g.mapleader = " "
        vim.keymap.set("x", "<leader>p", '"_dp')

        vim.g.markdown_fenced_languages = {
          "ts=typescript"
        }

        require("lazy").setup({
          spec = {
            {import = "rs.plugins"}
          },
          performance = {
            reset_packpath = false,
            rtp = {
              reset = false,
            }
          },
          dev = {
            path = "${pkgs.neovimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
            patterns = {
              "antoinemadec",
              "catppuccin",
              "catppuccin-nvim",
              "folke",
              "j-hui",
              "knubie",
              "leoluz",
              "lewis6991",
              "mfussenegger",
              "mrcjkb",
              "muniftanjim",
              "neovim",
              "numtostr",
              "nvim-lua",
              "nvim-lualine",
              "nvim-neotest",
              "nvim-treesitter",
              "pmizio",
              "rcarriga",
              "saecki",
              "saghen",
              "stevearc",
              "thehamsta",
              "windwp",
            },
          },
          install = {
            missing = false
          }
        })

        -- :help <opt>
        vim.opt.cmdheight = 1
        vim.opt.showmatch = true
        vim.opt.relativenumber = true
        vim.opt.number = true
        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        vim.opt.hidden = true
        vim.opt.cursorline = true
        vim.opt.equalalways = true
        vim.opt.splitright = true
        vim.opt.splitbelow = true
        vim.opt.updatetime = 1000
        vim.opt.scrolloff = 10

        vim.opt.autoindent = true
        vim.opt.cindent = true
        vim.opt.wrap = true

        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.softtabstop = 4
        vim.opt.expandtab = true
        vim.opt.textwidth = 120

        vim.opt.breakindent = true
        vim.opt.linebreak = true

        vim.opt.foldmethod = "marker"
        vim.opt.foldlevel = 0
        vim.opt.modelines = 1

        vim.opt.belloff = "all"

        vim.opt.clipboard = "unnamedplus"

        vim.opt.inccommand = "split"
        vim.opt.shada = { "!", "'1000", "<50", "s10", "h" }

        vim.opt.mouse = "a"

        vim.opt.formatoptions = vim.opt.formatoptions - "a" - "t" + "c" + "q" - "o" + "r" + "n" + "j" - "2"
      '';
    };

    xdg.configFile."nvim/lua" = {
      recursive = true;
      source = ./nvim/lua;
    };
    xdg.configFile."nvim/after" = {
      recursive = true;
      source = ./nvim/after;
    };

    catppuccin.nvim.enable = false;
  };
}
