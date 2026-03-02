{ ... }:
{
  flake.homeModules.claude-code =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.claude-code;
      jsonFormat = pkgs.formats.json { };
      mcpFile = jsonFormat.generate "claude-mcp-servers.json" (
        {

          # ── Core/Official Reference Servers ────────────────────

          memory = {
            command = "npx";
            args = [
              "-y"
              "@modelcontextprotocol/server-memory"
            ];
          };

          sequential-thinking = {
            command = "npx";
            args = [
              "-y"
              "@modelcontextprotocol/server-sequential-thinking"
            ];
          };

          # ── Cloud/Infrastructure ───────────────────────────────

          aws-api = {
            command = "uvx";
            args = [ "awslabs.aws-api-mcp-server@latest" ];
            env = {
              FASTMCP_LOG_LEVEL = "ERROR";
            };
          };

          aws-docs = {
            command = "uvx";
            args = [ "awslabs.aws-documentation-mcp-server@latest" ];
            env = {
              FASTMCP_LOG_LEVEL = "ERROR";
            };
          };

          kubernetes = {
            command = "npx";
            args = [
              "-y"
              "mcp-server-kubernetes"
            ];
          };

          terraform = {
            command = "npx";
            args = [
              "-y"
              "terraform-mcp-server"
            ];
          };

          # ── Nix ────────────────────────────────────────────────

          nixos = {
            command = "uvx";
            args = [ "mcp-nixos" ];
          };
        }

        # ── Optional servers (require 1Password references) ────

        // lib.optionalAttrs (cfg.github.pat != null) {
          github = {
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
        // lib.optionalAttrs (cfg.argocd.url != null && cfg.argocd.token != null) {
          argocd = {
            command = "op";
            args = [
              "run"
              "--"
              "npx"
              "-y"
              "argocd-mcp@latest"
              "stdio"
            ];
            env = {
              ARGOCD_BASE_URL = cfg.argocd.url;
              ARGOCD_AUTH_TOKEN = cfg.argocd.token;
            };
          };
        }
        // lib.optionalAttrs (cfg.grafana.url != null && cfg.grafana.token != null) {
          grafana = {
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
        }
      );
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

        argocd = {
          url = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "1Password reference for ArgoCD base URL";
          };
          token = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "1Password reference for ArgoCD auth token";
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
      };

      config = lib.mkIf cfg.enable {
        # Runtime dependencies for MCP servers (uvx for Python-based, npx for Node-based)
        home.packages = with pkgs; [
          uv
          nodejs
        ];

        # Merge MCP servers into ~/.claude.json (user-scoped, preserves mutable state)
        home.activation.claude-mcp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          claudeJson="$HOME/.claude.json"
          if [ -f "$claudeJson" ]; then
            run ${pkgs.jq}/bin/jq -s '.[0] + {mcpServers: .[1]}' "$claudeJson" "${mcpFile}" > "$claudeJson.tmp"
            run mv "$claudeJson.tmp" "$claudeJson"
          else
            run ${pkgs.jq}/bin/jq '{mcpServers: .}' "${mcpFile}" > "$claudeJson"
          fi
        '';

        programs.claude-code = {
          enable = true;

          # ── Settings (permissions + preferences) ─────────────────
          settings = {
            alwaysThinkingEnabled = true;

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

                # ── Read-only AWS ──────────────────────────────────
                "Bash(aws sts get-caller-identity:*)"
                "Bash(aws s3 ls:*)"

                # ── Read-only Git ──────────────────────────────────
                "Bash(git status:*)"
                "Bash(git log:*)"
                "Bash(git diff:*)"
                "Bash(git branch:*)"

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
