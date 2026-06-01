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

      # ── gh api mutation guard (PreToolUse hook) ───────────────────
      # Lets us allowlist read-only `gh api` (file contents, repo
      # exploration) without risking silent writes. Blocks (exit 2,
      # which overrides allow rules) any gh api call carrying a write
      # method or field flag — inspecting the FULL command so a chained
      # `&& gh api … -X DELETE` is caught too. Never emits "allow", so
      # there is no compound-command bypass; approval is left to the
      # allowlist's own per-segment evaluation. Fails closed for gh api.
      ghApiGuard = pkgs.writeShellScript "claude-gh-api-guard" ''
        export PATH=${
          lib.makeBinPath [
            pkgs.jq
            pkgs.gnugrep
            pkgs.coreutils
          ]
        }:$PATH
        cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null)
        [ -z "$cmd" ] && exit 0
        # Only inspect commands that actually invoke `gh api`.
        if printf '%s' "$cmd" | grep -qE '(^|[;&|[:space:]])gh[[:space:]]+api([[:space:]]|$)'; then
          if printf '%s' "$cmd" | grep -qiE '(-X[[:space:]=]*|--method[[:space:]=]+)(POST|PUT|PATCH|DELETE)' \
            || printf '%s' "$cmd" | grep -qE '(^|[[:space:]])(-f|-F|--field|--raw-field|--input)([[:space:]=]|$)' \
            || printf '%s' "$cmd" | grep -qiE 'graphql.*mutation'; then
            echo "Blocked: mutating gh api call detected (write method or field flag). Only read-only GET gh api is auto-allowed — run intentional writes yourself." >&2
            exit 2
          fi
        fi
        exit 0
      '';

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
      # ── MCP servers ───────────────────────────────────────────────
      # Fed to the native programs.claude-code.mcpServers option, which
      # generates a managed .mcp.json passed to the claude wrapper via
      # --plugin-dir (globally applied, without mutating ~/.claude.json).
      mcpServers = {
        aws-docs = {
          type = "stdio";
          command = "uvx";
          args = [ "awslabs.aws-documentation-mcp-server@latest" ];
          env = {
            FASTMCP_LOG_LEVEL = "ERROR";
          };
        };

        nixos = {
          type = "stdio";
          command = "uvx";
          args = [ "mcp-nixos" ];
        };

        # Cargo.lock-aware Rust crate documentation from docs.rs.
        docsrs = {
          type = "stdio";
          command = "${docsrs-mcp}/bin/docsrs-mcp";
        };
      }
      # ── Optional servers (require 1Password references) ────
      // lib.optionalAttrs (cfg.github.pat != null) {
        github = {
          type = "stdio";
          command = "op";
          args = [
            "run"
            "--"
            "docker"
            "run"
            "-i"
            "--rm"
            "-e"
            "GITHUB_PERSONAL_ACCESS_TOKEN"
            "ghcr.io/github/github-mcp-server"
          ];
          env = {
            GITHUB_PERSONAL_ACCESS_TOKEN = cfg.github.pat;
          };
        };
      }
      // lib.optionalAttrs (cfg.gitlab.pat != null && cfg.gitlab.apiUrl != null) {
        gitlab = {
          type = "stdio";
          command = "op";
          args = [
            "run"
            "--"
            "npx"
            "-y"
            "@modelcontextprotocol/server-gitlab"
          ];
          env = {
            GITLAB_PERSONAL_ACCESS_TOKEN = cfg.gitlab.pat;
            GITLAB_API_URL = cfg.gitlab.apiUrl;
          };
        };
      }
      // lib.optionalAttrs (cfg.grafana.url != null && cfg.grafana.token != null) {
        grafana = {
          type = "stdio";
          command = "op";
          args = [
            "run"
            "--"
            "uvx"
            "mcp-grafana"
          ];
          env = {
            GRAFANA_URL = cfg.grafana.url;
            GRAFANA_SERVICE_ACCOUNT_TOKEN = cfg.grafana.token;
          };
        };
      };
    in
    {
      options.claude-code = {
        enable = lib.mkEnableOption "enables claude-code";

        # ── 1Password-backed MCP server options ─────────────────
        github.pat = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "1Password reference for GitHub PAT (e.g. op://Dev/github.com/password)";
        };

        gitlab = {
          pat = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "1Password reference for GitLab PAT";
          };
          apiUrl = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "1Password reference for GitLab API URL";
          };
        };

        grafana = {
          url = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "1Password reference for Grafana URL";
          };
          token = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "1Password reference for Grafana service account token";
          };
        };

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
        # Runtime dependencies for MCP servers (uvx for Python-based, npx for Node-based)
        home.packages =
          with pkgs;
          [
            uv
            nodejs
          ]
          ++ lspPackages;

        programs.claude-code = {
          enable = true;
          package = inputs.claude-code-nix.packages.${pkgs.system}.default;

          # ── MCP servers (managed .mcp.json via --plugin-dir) ─────
          inherit mcpServers;

          # ── Settings (permissions + preferences) ─────────────────
          settings = {
            alwaysThinkingEnabled = true;
            editorMode = "vim";

            # ── PreToolUse hooks ─────────────────────────────────
            hooks = {
              PreToolUse = [
                {
                  matcher = "Bash";
                  hooks = [
                    {
                      type = "command";
                      command = "${ghApiGuard}";
                    }
                  ];
                }
              ];
            };

            permissions = {
              allow = [
                # ── Read-only filesystem exploration ───────────────
                "Bash(eza:*)"
                "Bash(ls:*)"
                "Bash(fd:*)"
                "Bash(find:*)"
                "Bash(rg:*)"
                "Bash(grep:*)"
                "Bash(cat:*)"
                "Bash(bat:*)"
                "Bash(head:*)"
                "Bash(tail:*)"
                "Bash(less:*)"
                "Bash(tree:*)"
                "Bash(file:*)"
                "Bash(wc:*)"
                "Bash(which:*)"
                "Bash(type:*)"
                "Bash(command:*)"

                # ── Data processing ────────────────────────────────
                "Bash(jq:*)"
                "Bash(yq:*)"

                # ── Read-only Kubernetes ───────────────────────────
                "Bash(kubectl get:*)"
                "Bash(kubectl logs:*)"
                "Bash(kubectl describe:*)"
                "Bash(kubectl explain:*)"
                "Bash(kubectl top:*)"
                "Bash(kubectl events:*)"
                "Bash(kubectl diff:*)"
                "Bash(kubectl api-resources:*)"
                "Bash(kubectl api-versions:*)"
                "Bash(kubectl cluster-info:*)"
                "Bash(kubectl version:*)"
                "Bash(kubectl auth can-i:*)"
                "Bash(kubectl config view:*)"
                "Bash(kubectl config get-contexts:*)"
                "Bash(kubectl config current-context:*)"

                # ── Read-only AWS (any service) ────────────────────
                # `*` spans tokens, so these match the read verb in any
                # service's command. Mutating verbs (create-/delete-/
                # update-/put-/modify-/…) are not matched and so prompt.
                "Bash(aws * get-*)"
                "Bash(aws * describe-*)"
                "Bash(aws * list-*)"
                "Bash(aws s3 ls:*)"

                # ── Read-only Git ──────────────────────────────────
                "Bash(git status:*)"
                "Bash(git log:*)"
                "Bash(git diff:*)"
                "Bash(git branch:*)"

                # ── Read-only GitHub CLI ───────────────────────────
                # `gh search`/view/list/diff cannot mutate. `gh api` is
                # allowed for read access (file contents, etc.) but is
                # guarded by the ghApiGuard PreToolUse hook, which hard-
                # blocks any write method/field flag (see hooks below).
                # File contents: gh api -H "Accept: application/vnd.github.raw" repos/O/R/contents/PATH
                "Bash(gh search:*)"
                "Bash(gh repo view:*)"
                "Bash(gh repo list:*)"
                "Bash(gh release view:*)"
                "Bash(gh release list:*)"
                "Bash(gh issue view:*)"
                "Bash(gh issue list:*)"
                "Bash(gh pr view:*)"
                "Bash(gh pr list:*)"
                "Bash(gh pr diff:*)"
                "Bash(gh api:*)"

                # ── Nix ────────────────────────────────────────────
                "Bash(nix search:*)"
                "Bash(nix fmt:*)"
                "Bash(nix flake show:*)"
                "Bash(nix flake check:*)"
                "Bash(nix eval:*)"
                "Bash(home-manager generations:*)"

                # ── Build/test runners ─────────────────────────────
                "Bash(./gradlew build:*)"
                "Bash(./gradlew test:*)"
                # Rust
                "Bash(cargo build:*)"
                "Bash(cargo test:*)"
                "Bash(cargo check:*)"
                "Bash(cargo clippy:*)"
                # Go
                "Bash(go build:*)"
                "Bash(go test:*)"
                "Bash(go vet:*)"
                # Maven
                "Bash(mvn compile:*)"
                "Bash(mvn test:*)"
                "Bash(mvn verify:*)"
                "Bash(mvn package:*)"
                # .NET
                "Bash(dotnet build:*)"
                "Bash(dotnet test:*)"
                "Bash(dotnet restore:*)"
                "Bash(pnpm outdated:*)"
                "Bash(pnpm typecheck:*)"
                "Bash(pnpm check:*)"
                "Bash(pnpm test:all:*)"
                "Bash(npm view:*)"
                "Bash(deno lint:*)"
                "Bash(deno fmt:*)"
                "Bash(deno task:*)"

                # ── Web ────────────────────────────────────────────
                "WebSearch"
                "WebFetch(domain:opentelemetry.io)"
                "WebFetch(domain:www.npmjs.com)"
                "WebFetch(domain:react.email)"
              ];

              deny = [
                # Prefer bash + jq over inline python scripts
                "Bash(python:*)"
                "Bash(python3:*)"
              ];

              defaultMode = "plan";
            };
          }
          // lib.optionalAttrs (cfg.lspPlugins != [ ]) {
            enabledPlugins = lspEnabledPlugins;
          };

          # ── Rules ────────────────────────────────────────────────
          rules = {
            modern-coreutils = ''
              # Modern Coreutils Preferences

              When running shell commands, always prefer these modern replacements
              over traditional Unix utilities:

              - Use `eza` instead of `ls` (supports `eza -l`, `eza -la`, `eza --tree`)
              - Use `fd` instead of `find` (e.g., `fd pattern` instead of `find . -name 'pattern'`)
              - Use `rg` (ripgrep) instead of `grep` (e.g., `rg pattern` instead of `grep -r pattern`)
              - Use `bat` instead of `cat` for viewing files (syntax highlighting, line numbers)
              - Use `sd` instead of `sed` when available (e.g., `sd 'from' 'to'` instead of `sed 's/from/to/g'`)
              - Use `dust` instead of `du` when available
              - Use `procs` instead of `ps` when available
              - Use `btop` or `htop` instead of `top`

              These tools are already installed in the user's environment.
            '';

            workflow = ''
              # Workflow Preferences

              ## Data Processing
              - Use `jq` for JSON processing. Never use `python -m json.tool` or inline python scripts.
              - Use `yq` for YAML processing.
              - Use bash pipelines with `jq`/`yq` for data transformation instead of python scripts.

              ## Kubernetes
              - Prefer read-only kubectl commands (get, logs, describe, explain) by default.
              - Always confirm before running mutating kubectl commands (apply, delete, patch, edit, scale).
              - Use `kubectl get -o yaml` or `kubectl get -o json | jq` for detailed resource inspection.

              ## AWS
              - Prefer read-only AWS CLI operations (describe-*, get-*, list-*) by default.
              - Always confirm before running mutating AWS operations (create-*, delete-*, update-*, put-*).
              - Use `aws sts get-caller-identity` to verify which account/role is active.
            '';
          };
        };
      };
    };
}
