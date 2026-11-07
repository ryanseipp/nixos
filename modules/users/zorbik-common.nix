{ ... }:
{
  # Everything shared between hosts for user zorbik. Hosts import this
  # alongside the per-OS profile (zorbik-darwin / zorbik-linux).
  flake.homeProfiles.zorbik-common =
    { pkgs, ... }:
    {
      catppuccin = {
        enable = true;
        autoEnable = true;
        flavor = "mocha";
      };

      home = {
        username = "zorbik";
        preferXdgDirectories = true;

        shellAliases = {
          ls = "eza -l";
          la = "eza -la";
        };

        packages = with pkgs; [
          # Modern coreutils
          dust
          procs
          sd

          # Kubernetes tooling
          argocd
          cilium-cli
          crossplane-cli
          # helmfile with its own internal helm + diff/secrets/s3/git plugins;
          # that helm isn't exposed on PATH, hence kubernetes-helm below.
          helmfile-wrapped
          hubble
          kind
          kubectl
          kubectl-cnpg
          kubectl-tree
          kubectx
          kubernetes-helm
          kubescape
          # standalone binary for helmfile; `kubectl apply -k` uses kubectl's built-in copy
          kustomize

          # OCI build / supply-chain (docker comes from the docker module)
          cosign
          trivy

          # Development tools
          crane
          devbox
          just
          maven
          opentofu
          quarkus
          slsa-verifier
          subnetcalc
          yq-go
        ];
      };

      # Exports XDG_*_HOME so tools that honour them agree with the paths the
      # zsh module hardcodes via config.xdg.*.
      xdg.enable = true;

      git = {
        enable = true;
        userName = "Ryan Seipp";
        userEmail = "rseipp@ryanseipp.com";
      };

      claude-code = {
        enable = true;
        lspPlugins = [
          "rust"
          "go"
        ];
      };
      codex.enable = true;
      mcp.enable = true;
      openrig.enable = true;
      neovim.enable = true;
      bat.enable = true;
      btop.enable = true;
      docker.enable = true;
      starship.enable = true;
      yazi.enable = true;
      zen-browser.enable = true;
      zsh.enable = true;
      zsh.enableFzf = true;

      # home-manager is pinned to master, so news would print on every rebuild.
      news.display = "silent";

      # home-manager's manpage build emits an uncontexted-store-path warning
      # upstream; we don't use `man home-configuration.nix`.
      manual.manpages.enable = false;

      programs = {
        eza = {
          enable = true;
          icons = "auto";
          git = true;
        };
        fd.enable = true;
        jq.enable = true;
        ripgrep.enable = true;

        k9s.enable = true;
        lazygit.enable = true;
        obsidian.enable = true;

        ssh = {
          enable = true;
          enableDefaultConfig = false;
        };

        direnv = {
          enable = true;
          nix-direnv.enable = true;
          enableBashIntegration = false;
          enableFishIntegration = false;
          enableNushellIntegration = false;
          config.global.hide_env_diff = true;
        };
      };
    };
}
