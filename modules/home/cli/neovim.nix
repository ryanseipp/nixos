{ inputs, ... }: {
  flake.homeModules.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (lib.generators) mkLuaInline;
    in
    {
      imports = [ inputs.nvf.homeManagerModules.default ];

      options = {
        neovim.enable = lib.mkEnableOption "enables neovim";
      };

      config = lib.mkIf config.neovim.enable {
        home.shellAliases.n = "nvim";

        # Make neovim the default editor for git, claude-code, and anything
        # that respects $EDITOR/$VISUAL.
        home.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };

        catppuccin.nvim.enable = false;

        programs.nvf = {
          enable = true;
          settings.vim = {
            viAlias = false;
            vimAlias = true;
            withNodeJs = true;
            withPython3 = true;

            theme = {
              enable = true;
              name = "catppuccin";
              style = "mocha";
              transparent = true;
            };

            globals = {
              mapleader = " ";
            };

            options = {
              cmdheight = 1;
              showmatch = true;
              relativenumber = true;
              number = true;
              ignorecase = true;
              smartcase = true;
              hidden = true;
              cursorline = true;
              equalalways = true;
              splitright = true;
              splitbelow = true;
              updatetime = 1000;
              scrolloff = 10;
              autoindent = true;
              cindent = true;
              wrap = true;
              tabstop = 4;
              shiftwidth = 4;
              softtabstop = 4;
              expandtab = true;
              textwidth = 120;
              breakindent = true;
              linebreak = true;
              foldmethod = "marker";
              foldlevel = 0;
              modelines = 1;
              belloff = "all";
              clipboard = "unnamedplus";
              inccommand = "split";
              mouse = "a";
              # Neovim 0.11+: default border for LSP hover/signature floats.
              winborder = "rounded";
            };

            luaConfigPost = ''
              vim.opt.shada = { "!", "'1000", "<50", "s10", "h" }
              vim.opt.formatoptions = vim.opt.formatoptions - "a" - "t" + "c" + "q" - "o" + "r" + "n" + "j" - "2"
            '';

            keymaps = [
              {
                mode = "x";
                key = "<leader>p";
                action = "\"_dp";
                desc = "Paste without yanking";
              }

              # Window navigation
              {
                mode = "n";
                key = "<c-h>";
                action = "<c-w>h";
                desc = "Window left";
              }
              {
                mode = "n";
                key = "<c-j>";
                action = "<c-w>j";
                desc = "Window down";
              }
              {
                mode = "n";
                key = "<c-k>";
                action = "<c-w>k";
                desc = "Window up";
              }
              {
                mode = "n";
                key = "<c-l>";
                action = "<c-w>l";
                desc = "Window right";
              }

              # Snacks picker / explorer / git / search
              {
                mode = "n";
                key = "<leader><space>";
                lua = true;
                action = "function() Snacks.picker.smart() end";
                desc = "Smart find files";
              }
              {
                mode = "n";
                key = "<leader>,";
                lua = true;
                action = "function() Snacks.picker.buffers() end";
                desc = "Buffers";
              }
              {
                mode = "n";
                key = "<leader>/";
                lua = true;
                action = "function() Snacks.picker.grep() end";
                desc = "Grep";
              }
              {
                mode = "n";
                key = "<leader>:";
                lua = true;
                action = "function() Snacks.picker.command_history() end";
                desc = "Command history";
              }
              {
                mode = "n";
                key = "<leader>n";
                lua = true;
                action = "function() Snacks.picker.notifications() end";
                desc = "Notifications";
              }
              {
                mode = "n";
                key = "<leader>e";
                lua = true;
                action = "function() Snacks.explorer() end";
                desc = "File explorer";
              }
              {
                mode = "n";
                key = "<leader>ff";
                lua = true;
                action = "function() Snacks.picker.files() end";
                desc = "Find files";
              }
              {
                mode = "n";
                key = "<leader>fg";
                lua = true;
                action = "function() Snacks.picker.git_files() end";
                desc = "Git files";
              }
              {
                mode = "n";
                key = "<leader>fr";
                lua = true;
                action = "function() Snacks.picker.recent() end";
                desc = "Recent files";
              }
              {
                mode = "n";
                key = "<leader>fp";
                lua = true;
                action = "function() Snacks.picker.projects() end";
                desc = "Projects";
              }
              {
                mode = "n";
                key = "<leader>fc";
                lua = true;
                action = "function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end";
                desc = "Config files";
              }
              {
                mode = "n";
                key = "<leader>gb";
                lua = true;
                action = "function() Snacks.picker.git_branches() end";
                desc = "Git branches";
              }
              {
                mode = "n";
                key = "<leader>gl";
                lua = true;
                action = "function() Snacks.picker.git_log() end";
                desc = "Git log";
              }
              {
                mode = "n";
                key = "<leader>gs";
                lua = true;
                action = "function() Snacks.picker.git_status() end";
                desc = "Git status";
              }
              {
                mode = "n";
                key = "<leader>gd";
                lua = true;
                action = "function() Snacks.picker.git_diff() end";
                desc = "Git diff";
              }
              {
                mode = "n";
                key = "<leader>gg";
                lua = true;
                action = "function() Snacks.lazygit() end";
                desc = "Lazygit";
              }
              {
                mode = "n";
                key = "<leader>gB";
                lua = true;
                action = "function() Snacks.gitbrowse() end";
                desc = "Git browse";
              }
              {
                mode = "n";
                key = "<leader>sg";
                lua = true;
                action = "function() Snacks.picker.grep() end";
                desc = "Grep";
              }
              {
                mode = [
                  "n"
                  "x"
                ];
                key = "<leader>sw";
                lua = true;
                action = "function() Snacks.picker.grep_word() end";
                desc = "Word under cursor";
              }
              {
                mode = "n";
                key = "<leader>sd";
                lua = true;
                action = "function() Snacks.picker.diagnostics() end";
                desc = "Diagnostics";
              }
              {
                mode = "n";
                key = "<leader>sD";
                lua = true;
                action = "function() Snacks.picker.diagnostics_buffer() end";
                desc = "Buffer diagnostics";
              }
              {
                mode = "n";
                key = "<leader>sh";
                lua = true;
                action = "function() Snacks.picker.help() end";
                desc = "Help";
              }
              {
                mode = "n";
                key = "<leader>sk";
                lua = true;
                action = "function() Snacks.picker.keymaps() end";
                desc = "Keymaps";
              }
              {
                mode = "n";
                key = "<leader>sR";
                lua = true;
                action = "function() Snacks.picker.resume() end";
                desc = "Resume picker";
              }
              {
                mode = "n";
                key = "<leader>bd";
                lua = true;
                action = "function() Snacks.bufdelete() end";
                desc = "Delete buffer";
              }
              {
                mode = "n";
                key = "<leader>z";
                lua = true;
                action = "function() Snacks.zen() end";
                desc = "Zen mode";
              }
              {
                mode = "n";
                key = "<leader>.";
                lua = true;
                action = "function() Snacks.scratch() end";
                desc = "Scratch buffer";
              }
              {
                mode = "n";
                key = "<leader>un";
                lua = true;
                action = "function() Snacks.notifier.hide() end";
                desc = "Dismiss notifications";
              }
              {
                mode = "n";
                key = "<leader>uh";
                lua = true;
                action = "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 }) end";
                desc = "Toggle inlay hints";
              }
              {
                mode = "n";
                key = "<c-/>";
                lua = true;
                action = "function() Snacks.terminal() end";
                desc = "Terminal";
              }

              # LSP via snacks.picker. `grr` is Neovim's built-in references
              # key; overriding it (rather than `gr` with nowait) keeps the
              # rest of the built-in `gr*` family (grn/gra/gri/grt) reachable.
              {
                mode = "n";
                key = "gd";
                lua = true;
                action = "function() Snacks.picker.lsp_definitions() end";
                desc = "Go to definition";
              }
              {
                mode = "n";
                key = "gD";
                lua = true;
                action = "function() Snacks.picker.lsp_declarations() end";
                desc = "Go to declaration";
              }
              {
                mode = "n";
                key = "grr";
                lua = true;
                action = "function() Snacks.picker.lsp_references() end";
                desc = "References";
              }
              {
                mode = "n";
                key = "gI";
                lua = true;
                action = "function() Snacks.picker.lsp_implementations() end";
                desc = "Implementations";
              }
              {
                mode = "n";
                key = "gy";
                lua = true;
                action = "function() Snacks.picker.lsp_type_definitions() end";
                desc = "Type definitions";
              }
              {
                mode = "n";
                key = "<leader>ss";
                lua = true;
                action = "function() Snacks.picker.lsp_symbols() end";
                desc = "LSP symbols";
              }
              {
                mode = "n";
                key = "<leader>sS";
                lua = true;
                action = "function() Snacks.picker.lsp_workspace_symbols() end";
                desc = "Workspace symbols";
              }

              # Formatting
              {
                mode = [
                  "n"
                  "v"
                ];
                key = "<leader>rf";
                lua = true;
                action = "function() require('conform').format({ lsp_format = 'fallback', async = false }) end";
                desc = "Format file/range";
              }

              # DAP keymaps are configured via `vim.debugger.nvim-dap.mappings` below
              # (nvf wires them with proper lazy-load semantics for nvim-dap-ui).
              # `<leader>de` (dapui eval) is added here; it's safe because nvf auto-opens
              # dap-ui on DAP session init, so dapui is loaded before eval is ever pressed.
              {
                mode = "n";
                key = "<leader>de";
                lua = true;
                action = "function() require('dapui').eval() end";
                desc = "[DAP] Eval";
              }

              # Rust (rustaceanvim)
              {
                mode = "n";
                key = "<leader>rr";
                lua = true;
                action = "function() vim.cmd.RustLsp('run') end";
                desc = "[Rust] Run";
              }
              {
                mode = "n";
                key = "<leader>rrs";
                lua = true;
                action = "function() vim.cmd.RustLsp('runnables') end";
                desc = "[Rust] Runnables";
              }
              {
                mode = "n";
                key = "<leader>rd";
                lua = true;
                action = "function() vim.cmd.RustLsp('debug') end";
                desc = "[Rust] Debug";
              }
              {
                mode = "n";
                key = "<leader>rds";
                lua = true;
                action = "function() vim.cmd.RustLsp('debuggables') end";
                desc = "[Rust] Debuggables";
              }
              {
                mode = "n";
                key = "<leader>rts";
                lua = true;
                action = "function() vim.cmd.RustLsp('testables') end";
                desc = "[Rust] Testables";
              }
              {
                mode = "n";
                key = "<leader>rem";
                lua = true;
                action = "function() vim.cmd.RustLsp('expandMacro') end";
                desc = "[Rust] Expand macro";
              }

              # Crates
              {
                mode = "n";
                key = "<leader>pc";
                lua = true;
                action = "function() require('crates').show_crate_popup() end";
                desc = "[Crates] Popup";
              }
              {
                mode = "n";
                key = "<leader>pd";
                lua = true;
                action = "function() require('crates').show_dependencies_popup() end";
                desc = "[Crates] Deps";
              }
              {
                mode = "n";
                key = "<leader>pf";
                lua = true;
                action = "function() require('crates').show_features_popup() end";
                desc = "[Crates] Features";
              }
              {
                mode = "n";
                key = "<leader>pv";
                lua = true;
                action = "function() require('crates').show_versions_popup() end";
                desc = "[Crates] Versions";
              }

              # YAML schema selection (schema-companion.nvim)
              {
                mode = "n";
                key = "<leader>ys";
                lua = true;
                action = "function() require('schema-companion').select_schema() end";
                desc = "[YAML] Select schema";
              }
              {
                mode = "n";
                key = "<leader>yS";
                lua = true;
                action = "function() require('schema-companion').select_from_matching_schemas() end";
                desc = "[YAML] Select from matching schemas";
              }
            ];

            autocomplete.blink-cmp = {
              enable = true;
              setupOpts = {
                keymap.preset = "default";
                appearance = {
                  use_nvim_cmp_as_default = false;
                  nerd_font_variant = "normal";
                };
                sources = {
                  # nvf already adds lsp/path/snippets/buffer; lists concatenate.
                  default = [ "lazydev" ];
                  providers.lazydev = {
                    name = "LazyDev";
                    module = "lazydev.integrations.blink";
                    score_offset = 100;
                  };
                };
                signature.enabled = true;
                fuzzy.implementation = "prefer_rust_with_warning";
              };
            };

            lsp = {
              enable = true;
              formatOnSave = true;
              inlayHints.enable = true;
              lightbulb.enable = true;
              trouble.enable = true;
              # No nvf language module enables tailwind; the preset carries the
              # cmd, filetypes, root_dir and workspace_required.
              presets.tailwindcss-language-server.enable = true;
              # Keys here must match nvf's server registry names exactly: a key
              # nvf doesn't know is emitted with no `cmd` and errors on every
              # buffer. rust-analyzer is configured via rustaceanvim (languages.rust).
              servers = {
                # Protobuf — no nvf language module exists
                buf_ls = {
                  cmd = [
                    (lib.getExe pkgs.buf)
                    "beta"
                    "lsp"
                  ];
                  filetypes = [ "proto" ];
                  root_markers = [
                    "buf.yaml"
                    "buf.work.yaml"
                  ];
                };
                tailwindcss-language-server = {
                  # The preset already lists every common template/CSS/JS
                  # filetype; lists concatenate, so only add what's missing.
                  filetypes = [ "mdx" ];
                  init_options.userLanguages.rust = "html";
                };
                # cmd comes from nvf's preset (pkgs.clang-tools); Neovim 0.11+
                # negotiates the offset encoding per client.
                clangd.init_options.clangdFileStatus = true;
                # YAML schemas: SchemaStore.nvim owns the catalog; schema-companion.nvim
                # does content-based K8s/CRD dispatch via apiVersion+kind. Both are
                # lazy-loaded (see lazy.plugins) and wired in on_attach below.
                # For off-catalog files (e.g. Talos machineconfig), add a modeline:
                #   # yaml-language-server: $schema=<URL>
                yaml-language-server = {
                  settings.yaml = {
                    keyOrdering = false;
                    # Disable yamlls's stale built-in schemastore fetch.
                    schemaStore = {
                      enable = false;
                      url = "";
                    };
                    # Empty at registration so SchemaStore.nvim stays lazy.
                    # Pushed via didChangeConfiguration from on_attach below.
                    schemas = { };
                    validate = true;
                    schemaDownload.enable = true;
                  };
                  on_attach = mkLuaInline ''
                    function(client, bufnr)
                      if default_on_attach then default_on_attach(client, bufnr) end
                      if not client.__nvf_schemas_loaded then
                        client.__nvf_schemas_loaded = true
                        local ok, schemastore = pcall(require, "schemastore")
                        if ok then
                          client.config.settings = vim.tbl_deep_extend("force",
                            client.config.settings or {},
                            { yaml = { schemas = schemastore.yaml.schemas() } })
                          client:notify("workspace/didChangeConfiguration",
                            { settings = client.config.settings })
                        end
                      end
                      local sc_ok, sc = pcall(require, "schema-companion")
                      if sc_ok and sc.on_attach then sc.on_attach(client, bufnr) end
                    end
                  '';
                };
              };
            };

            languages = {
              enableTreesitter = true;
              enableFormat = true;
              enableDAP = true;
              enableExtraDiagnostics = true;

              # First-class language modules
              nix.enable = true;
              rust = {
                enable = true;
                # rustaceanvim owns rust-analyzer and the debug adapter; nvf
                # asserts that its plain LSP/DAP presets are off when it is on.
                lsp.enable = false;
                dap.enable = false;
                # Only read for rustaceanvim's adapter default: lldb-dap from
                # pkgs.lldb, which works on both Linux and macOS.
                dap.debugger = [ "lldb" ];
                # Keep the manual conform entry (rustfmt + leptosfmt + rustywind);
                # nvf's rust formatter would overwrite it with plain rustfmt.
                format.enable = false;
                extensions.crates-nvim.enable = true;
                extensions.rustaceanvim = {
                  enable = true;
                  # Any `server` definition replaces nvf's default wholesale,
                  # so restate cmd here.
                  setupOpts.server = {
                    cmd = [ (lib.getExe pkgs.rust-analyzer) ];
                    default_settings."rust-analyzer" = {
                      cargo = {
                        buildScripts.enable = true;
                        features = "all";
                      };
                      checkOnSave = true;
                    };
                  };
                };
              };
              go = {
                enable = true;
                dap.enable = true;
                # golangci-lint via extraDiagnostics default
              };
              java.enable = true;
              python = {
                enable = true;
                # basedpyright for types, ruff LSP for lint + import fixes
                lsp.servers = [
                  "basedpyright"
                  "ruff"
                ];
                format.type = [ "ruff" ];
                # Skip mypy; ruff LSP already provides diagnostics
                extraDiagnostics.enable = false;
              };
              # nvf's "typescript-go" key is TS 7's native `tsc --lsp` from
              # pkgs.typescript; the name predates TS 7 going stable.
              typescript = {
                enable = true;
                lsp = {
                  enable = true;
                  servers = [ "typescript-go" ];
                };
                format.type = [ "biome" ];
                extraDiagnostics.types = [ "biomejs" ];
              };
              tsx = {
                enable = true;
                lsp = {
                  enable = true;
                  servers = [ "typescript-go" ];
                };
                format.type = [ "biome" ];
              };
              bash.enable = true;
              yaml.enable = true;
              terraform.enable = true;
              lua = {
                enable = true;
                # nvf's first-class lazydev integration — lazy-loaded on
                # `ft = "lua"`, which is exactly when blink-cmp's lazydev
                # provider is used.
                extensions.lazydev.enable = true;
              };
              docker.enable = true;
              helm.enable = true;
              html.enable = true;
              css = {
                enable = true;
                format.type = [ "biome" ];
              };
              json.enable = true;
              # astro.enable = true;
              zig.enable = true;
              clang.enable = true;
              markdown.enable = true;
            };

            diagnostics.nvim-lint = {
              enable = true;
              linters_by_ft = {
                # actionlint for GitHub Actions workflow YAML
                yaml = [ "actionlint" ];
              };
              # nvf has no actionlint preset; give nvim-lint's builtin a store
              # path and only run it in repos that have workflows.
              linters.actionlint = {
                cmd = lib.getExe pkgs.actionlint;
                required_files = [ ".github/workflows" ];
              };
            };

            formatter.conform-nvim = {
              enable = true;
              setupOpts = {
                # nvf defaults BOTH format_on_save (sync) and format_after_save
                # (async), which formats and writes twice. Keep a single guarded
                # sync pass that honours the <leader>ltf toggle.
                format_on_save = mkLuaInline ''
                  function()
                    if not vim.g.formatsave or vim.b.disableFormatSave then return end
                    return { lsp_format = "fallback", timeout_ms = 1000 }
                  end
                '';
                format_after_save = null;
                # Per-filetype entries that nvf language modules already define
                # (c, css, sh, terraform) are set via languages.<lang>.format.
                formatters_by_ft = {
                  rust = [
                    "rustfmt"
                    "leptosfmt"
                    "rustywind"
                  ];
                  bash = [ "shfmt" ];
                  zsh = [ "shfmt" ];
                };
                formatters = {
                  shfmt.prepend_args = [
                    "-i"
                    "4"
                  ];
                  leptosfmt.command = lib.getExe pkgs.leptosfmt;
                  rustywind.command = lib.getExe pkgs.rustywind;
                };
              };
            };

            statusline.lualine = {
              enable = true;
              # "auto" derives colors from the active colorscheme; avoids a
              # load-order race with catppuccin's lualine theme module.
              setupOpts.options.theme = "auto";
            };

            git.gitsigns.enable = true;

            visuals = {
              fidget-nvim.enable = true;
              nvim-web-devicons.enable = true;
            };

            debugger.nvim-dap = {
              enable = true;
              ui.enable = true;
              mappings = {
                stepBack = "<F1>";
                stepInto = "<F2>";
                stepOver = "<F3>";
                stepOut = "<F4>";
                continue = "<F5>";
                toggleBreakpoint = "<leader>db";
                toggleRepl = "<leader>do";
                # toggleDapUI defaults to <leader>du — keep that
              };
            };

            autopairs.nvim-autopairs.enable = true;
            comments.comment-nvim.enable = true;
            binds.whichKey.enable = true;

            lazy.plugins = {
              "snacks.nvim" = {
                package = pkgs.vimPlugins.snacks-nvim;
                setupModule = "snacks";
                setupOpts = {
                  bigfile.enabled = true;
                  dashboard = {
                    enabled = true;
                    sections = [
                      { section = "header"; }
                      {
                        section = "keys";
                        gap = 1;
                        padding = 1;
                      }
                      {
                        section = "recent_files";
                        cwd = true;
                        limit = 8;
                        padding = 1;
                      }
                      {
                        section = "projects";
                        padding = 1;
                      }
                    ];
                  };
                  indent = {
                    enabled = true;
                    animate.enabled = false;
                    scope.animate.enabled = false;
                  };
                  input.enabled = true;
                  picker = {
                    enabled = true;
                    # Top-level picker.hidden means something else (which
                    # windows to hide); dotfiles are per-source.
                    sources = {
                      files.hidden = true;
                      grep.hidden = true;
                      explorer.hidden = true;
                    };
                  };
                  notifier.enabled = true;
                  statuscolumn.enabled = true;
                  quickfile.enabled = true;
                  scope.enabled = true;
                  scratch.enabled = true;
                  words.enabled = true;
                };
                lazy = false;
              };
              "render-markdown.nvim" = {
                package = pkgs.vimPlugins.render-markdown-nvim;
                setupModule = "render-markdown";
                setupOpts = { };
                ft = [ "markdown" ];
              };
              "nvim-treesitter-context" = {
                package = pkgs.vimPlugins.nvim-treesitter-context;
                setupModule = "treesitter-context";
                setupOpts = { };
                event = [
                  "BufReadPost"
                  "BufNewFile"
                ];
              };
              # SchemaStore catalog — required lazily from yamlls on_attach.
              "SchemaStore.nvim" = {
                package = pkgs.vimPlugins.SchemaStore-nvim;
                lazy = true;
              };
              # Content-based K8s/CRD schema dispatch.
              "schema-companion.nvim" = {
                package = pkgs.vimPlugins.schema-companion-nvim;
                setupModule = "schema-companion";
                setupOpts = {
                  matchers = [
                    (mkLuaInline ''require("schema-companion.matchers.kubernetes").setup({ version = "master" })'')
                  ];
                };
                ft = [
                  "yaml"
                  "helm"
                ];
              };
              # Helm filetype detection for templates/*.yaml.
              "helm-ls.nvim" = {
                package = pkgs.vimPlugins.helm-ls-nvim;
                setupModule = "helm-ls";
                setupOpts = { };
                event = [ "BufReadPre" ];
              };
            };
          };
        };
      };
    };
}
