{ ... }:
{
  # Shared MCP servers. Consumed by both claude-code and codex through their
  # home-manager `enableMcpIntegration` options, so each server is declared once.
  flake.homeModules.mcp =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.mcp;

      # ── docsrs-mcp: Cargo.lock-aware docs.rs documentation server ──
      # Not in nixpkgs (Rust binary); built from source. Resolves crate
      # versions from the active project's Cargo.lock at runtime.
      docsrs-mcp = pkgs.rustPlatform.buildRustPackage {
        pname = "docsrs-mcp";
        version = "0.1.0";
        src = pkgs.fetchFromGitHub {
          owner = "dmvk";
          repo = "docsrs-mcp";
          tag = "v0.1.0";
          hash = "sha256-5QoXTQ2QWDb+f6KCWgC7qTrUAobz9VlgRif3BfmvNmQ=";
        };
        cargoHash = "sha256-2TwNuXzqDr5H87RJyu4/0OSaGr3a6WnleCUTou9U2Ck=";
        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.openssl ];
      };
    in
    {
      options.mcp = {
        enable = lib.mkEnableOption "shared MCP servers for claude-code and codex";

        github.pat = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "1Password reference for GitHub PAT (e.g. op://Dev/github.com/password)";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.mcp = {
          enable = true;
          servers = {
            # NixOS / home-manager / nix-darwin options and nixpkgs search.
            # nixpkgs' mcp-nixos 3.0.1 needs fastmcp-slim, which is marked broken
            # against mcp >= 2; upstream 3.1.0 moved to fastmcp 4. Run the pinned
            # PyPI release until nixpkgs catches up, then return to pkgs.mcp-nixos.
            nixos = {
              command = "${pkgs.uv}/bin/uvx";
              args = [ "mcp-nixos==3.1.0" ];
            };

            # Cargo.lock-aware Rust crate documentation from docs.rs.
            docsrs.command = "${docsrs-mcp}/bin/docsrs-mcp";

            # gopls' built-in MCP server: Go workspace, package and symbol queries.
            gopls = {
              command = "${pkgs.gopls}/bin/gopls";
              args = [ "mcp" ];
            };

            # OAuth on first use (`/mcp` in claude, `codex mcp login linear`).
            linear.url = "https://mcp.linear.app/mcp";

            # The nixpkgs wrapper pins PLAYWRIGHT_BROWSERS_PATH to Nix-built
            # chromium/firefox/webkit and defaults to isolated chromium.
            playwright.command = "${pkgs.playwright-mcp}/bin/playwright-mcp";
          }
          // lib.optionalAttrs (cfg.github.pat != null) {
            github = {
              command = "op";
              args = [
                "run"
                "--"
                "${pkgs.github-mcp-server}/bin/github-mcp-server"
                "stdio"
              ];
              env.GITHUB_PERSONAL_ACCESS_TOKEN = cfg.github.pat;
            };
          };
        };
      };
    };
}
