{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {neovim.enable = lib.mkEnableOption "enables neovim";};

  config = lib.mkIf config.neovim.enable {
    home.shellAliases = {n = "nvim";};

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      withPython3 = true;
      withNodeJs = true;
      plugins = with pkgs.vimPlugins; [
        lazy-nvim

        # cmp
        nvim-cmp
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-buffer
        cmp-path
        luasnip

        # dap
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-dap-go

        # editing
        nvim-autopairs
        nvim-ts-autotag
        comment-nvim

        # lsp
        nvim-lspconfig
        fidget-nvim
        neodev-nvim
        none-ls-nvim

        rustaceanvim
        crates-nvim

        typescript-tools-nvim

        # misc
        plenary-nvim
        conform-nvim
        gitsigns-nvim

        # treesitter
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
        nvim-treesitter-context

        # telescope
        telescope-nvim
        telescope-dap-nvim
        telescope-fzf-native-nvim

        # ui
        catppuccin-nvim
        lualine-nvim
        dashboard-nvim
        nvim-web-devicons
        dressing-nvim
        noice-nvim
        nui-nvim
        nvim-notify
        nvim-tree-lua
        indent-blankline-nvim
        vim-tmux-navigator
      ];
      extraPackages = with pkgs; [
        alejandra
        beautysh
        clang-tools
        csharpier
        dockerfile-language-server-nodejs
        elixir-ls
        fzf
        gopls
        lldb
        lua-language-server
        nixd
        nodePackages.bash-language-server
        nodePackages.eslint
        nodePackages.prettier
        nodePackages."@astrojs/language-server"
        ocamlformat
        omnisharp-roslyn
        rust-analyzer
        rustywind
        shfmt
        stylua
        yaml-language-server
        vscode-extensions.vadimcn.vscode-lldb
        vscode-langservers-extracted
        zls
      ];

      extraLuaConfig = ''
        vim.g.mapleader = " "
        vim.keymap.set("x", "<leader>p", '"_dp')

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
            path = "${
          pkgs.vimUtils.packDir
          config.programs.neovim.finalPackage.passthru.packpathDirs
        }/pack/myNeovimPackages/start",
            patterns = { "catppuccin", "hrsh7th", "l3mon4d3", "saadparwaiz1", "williamboman", "neovim", "nvim-lua", "nvim-lualine", "nvim-telescope", "nvim-tree", "nvimdev", "j-hui", "folke", "mfussenegger", "tastyep", "mrcjkb", "saecki", "nvimtools", "pmizio", "windwp", "numtostr", "numToStr", "stevearc", "lewis6991", "muniftanjim", "rcarriga", "lukas-reineke", "christoomey", "thehamsta", "leoluz" }
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
  };
}
