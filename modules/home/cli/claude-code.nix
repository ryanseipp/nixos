{ ... }:
{
  flake.homeModules.claude-code =
    {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }:
    let
      cfg = config.claude-code;

      # ── LSP plugin registry ──────────────────────────────────────
      # Maps language enum -> { package (null if unavailable), pluginName }
      lspRegistry = {
        go = {
          package = pkgs.gopls;
          pluginName = "gopls-lsp";
        };
        typescript = {
          package = pkgs.typescript-language-server;
          pluginName = "typescript-lsp";
        };
        python = {
          package = pkgs.pyright;
          pluginName = "pyright-lsp";
        };
        java = {
          package = pkgs.jdt-language-server;
          pluginName = "jdtls-lsp";
        };
        rust = {
          package = pkgs.rust-analyzer;
          pluginName = "rust-analyzer-lsp";
        };
        csharp = {
          package = pkgs.csharp-ls;
          pluginName = "csharp-lsp";
        };
        cpp = {
          package = pkgs.clang-tools;
          pluginName = "clangd-lsp";
        };
        lua = {
          package = pkgs.lua-language-server;
          pluginName = "lua-lsp";
        };
        kotlin = {
          package = pkgs.kotlin-language-server;
          pluginName = "kotlin-lsp";
        };
        php = {
          package = pkgs.intelephense;
          pluginName = "php-lsp";
        };
        swift = {
          package = null;
          pluginName = "swift-lsp";
        };
      };

      lspPackages = lib.filter (p: p != null) (map (lang: lspRegistry.${lang}.package) cfg.lspPlugins);

      lspEnabledPlugins = lib.listToAttrs (
        map (
          lang: lib.nameValuePair "${lspRegistry.${lang}.pluginName}@claude-plugins-official" true
        ) cfg.lspPlugins
      );
    in
    {
      options.claude-code = {
        enable = lib.mkEnableOption "enables claude-code";

        # ── LSP plugin support ──────────────────────────────────────
        lspPlugins = lib.mkOption {
          type = lib.types.listOf (
            lib.types.enum [
              "go"
              "typescript"
              "python"
              "java"
              "rust"
              "csharp"
              "cpp"
              "lua"
              "kotlin"
              "php"
              "swift"
            ]
          );
          default = [ ];
          description = "Languages to enable LSP plugin support for. Installs LSP servers and enables claude-plugins-official plugins. Swift has no nixpkg — only the plugin setting is enabled.";
          example = [
            "go"
            "typescript"
            "python"
          ];
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = lspPackages ++ [ pkgs.nixd ];

        programs.claude-code = {
          enable = true;
          package = inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;

          # Exported as CLAUDE_CONFIG_DIR; .claude.json lives inside it too.
          configDir = "${config.xdg.configHome}/claude";

          # MCP servers come from the shared `mcp` module.
          enableMcpIntegration = true;

          # No official plugin exists for Nix; register nixd directly.
          lspServers.nix = {
            command = "${pkgs.nixd}/bin/nixd";
            extensionToLanguage.".nix" = "nix";
          };

          settings = {
            alwaysThinkingEnabled = true;
            editorMode = "vim";
          }
          // lib.optionalAttrs (cfg.lspPlugins != [ ]) {
            enabledPlugins = lspEnabledPlugins;
          };
        };
      };
    };
}
