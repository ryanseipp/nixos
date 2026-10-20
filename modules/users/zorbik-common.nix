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
          # Modern coreutils (see the claude-code modern-coreutils rule)
          dust
          procs
          sd

          # Kubernetes tooling
          kind
          kubectl
          kubectl-cnpg
          kubectl-tree
          kubectx
          kubescape

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
          "typescript"
          "rust"
          "java"
          "go"
          "python"
        ];
      };
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
