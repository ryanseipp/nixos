{
  pkgs,
  lib,
  config,
  inputs',
  ...
}:
let
  treesitter-rstml =
    (pkgs.tree-sitter.buildGrammar {
      version = "2.0.0";
      generate = false;
      location = "rust_with_rstml";
      language = "rust_with_rstml";
      src = pkgs.fetchFromGitHub {
        owner = "rayliwell";
        repo = "tree-sitter-rstml";
        rev = "07a8e3b9bda09b648a6ccaca09e15dea3adf956f";
        sha256 = "sha256-q66XIPssd8b3kjL1SDq8p23Zyo2BMBARPAXZ2TiAXPU=";
      };
    }).overrideAttrs
      (
        final: prev: {
          postInstall = ''
            rm -r $out/queries
            mkdir $out/queries
            cp -r ../queries/rust_with_rstml/. $out/queries
          '';
        }
      );
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
      plugins =
        [ inputs'.mcphub-nvim.packages.default ]
        ++ (with pkgs.vimPlugins; [
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

          # AI Plugins
          copilot-lua
          codecompanion-nvim
          render-markdown-nvim
          mini-diff

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
          (nvim-treesitter.withPlugins (_: nvim-treesitter.allGrammars ++ [ treesitter-rstml ]))
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
        ]);
      extraPackages = with pkgs; [
        astro-language-server
        bash-language-server
        beautysh
        biome
        buf
        clang-tools
        dockerfile-language-server-nodejs
        # eslint
        fzf
        gh
        gopls
        inputs'.mcphub.packages.default
        lua-language-server
        nixd
        nixfmt-rfc-style
        # nodePackages.prettier
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

      # Add this back if dotnet dev is necessary
      extraLuaConfig = ''
        vim.g.mapleader = " "
        vim.keymap.set("x", "<leader>p", '"_dp')

        vim.g.markdown_fenced_languages = {
          "ts=typescript"
        }
        vim.g.omnisharp_path = '${pkgs.omnisharp-roslyn}/bin/OmniSharp'
        vim.g.mcphub_path = '${inputs'.mcphub.packages.default}/bin/mcp-hub'

        local lsp = require("rs.lsp")

        vim.g.rustaceanvim = {
            server = {
                on_attach = lsp.custom_attach,
                default_settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            buildScripts = {
                                enable = true,
                            },
                            features = "all",
                        },
                        checkOnSave = true,
                    },
                },
            },
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
              "echasnovski",
              "folke",
              "j-hui",
              "knubie",
              "leoluz",
              "lewis6991",
              "meanderingprogrammer",
              "mfussenegger",
              "mrcjkb",
              "muniftanjim",
              "neovim",
              "numtostr",
              "nvim-lua",
              "nvim-lualine",
              "nvim-neotest",
              "nvim-treesitter",
              "olimorris",
              "pmizio",
              "ravitemer",
              "rcarriga",
              "saecki",
              "saghen",
              "stevearc",
              "thehamsta",
              "windwp",
              "zbirenbaum",
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
