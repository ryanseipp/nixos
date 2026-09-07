{ ... }:
let
  homeDirectory = "/Users/zorbik";
in
{
  flake.homeProfiles.zorbik-darwin = { pkgs, ... }: {
    catppuccin = {
      enable = true;
      autoEnable = true;
      flavor = "mocha";
    };

    home = {
      username = "zorbik";
      inherit homeDirectory;
      preferXdgDirectories = true;

      shellAliases = {
        ls = "eza -l";
        la = "eza -la";
      };

      packages = with pkgs; [
        crane
        devbox
        dive
        docker
        docker-compose
        eza
        fd
        gh
        graalvmPackages.graalvm-ce
        jq
        just
        kind
        kubectl
        kubectl-tree
        kubectl-cnpg
        kubectx
        kubescape
        maven
        opentofu
        poppler-utils
        quarkus
        ripgrep
        slsa-verifier
        subnetcalc
        yubikey-manager
        yubikey-personalization
        yq-go
      ];

      stateVersion = "25.11";
    };

    claude-code = {
      enable = true;
      github.pat = "op://Dev/GitHub PAT - Claude Code MCP/credential";
      lspPlugins = [
        "typescript"
        "rust"
        "java"
        "go"
        "python"
      ];
    };
    gc-hm.enable = true;
    neovim.enable = true;
    bat.enable = true;
    btop.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zsh.enable = true;
    zsh.enableFzf = true;
    starship.enable = true;

    ghostty = {
      enable = true;
      fontSize = 14;
    };

    aerospace = {
      enable = true;
      floatingAppIds = [ "com.mitchellh.ghostty" ];
    };

    zen-browser.enable = true;

    git = {
      enable = true;
      userName = "Ryan Seipp";
      userEmail = "rseipp@ryanseipp.com";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3zMo59N1hukphn9i0jvSdUN9ng3AmaP22gYbzk5HOK zorbik@hyperion-r.local";
      signingKeyPath = "${homeDirectory}/.ssh/id_ed25519";
    };

    # home-manager's manpage build emits an uncontexted-store-path warning
    # upstream; we don't use `man home-configuration.nix`.
    manual.manpages.enable = false;

    programs = {
      k9s.enable = true;
      lazygit.enable = true;
      obsidian.enable = true;

      zsh.initContent = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"

        # eval $(/opt/homebrew/bin/ssh-agent)
        # export SSH_ASKPASS=/usr/local/bin/ssh-askpass
        # export DISPLAY=":0"
      '';

      ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings."*" = {
          ForwardAgent = false;
          AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
          IdentityFile = "${homeDirectory}/.ssh/id_ed25519";
          IdentitiesOnly = "yes";
        };
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
    catppuccin.mako.enable = false;
  };
}
