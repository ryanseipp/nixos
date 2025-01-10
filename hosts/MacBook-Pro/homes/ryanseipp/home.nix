{
  pkgs,
  inputs,
  outputs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    outputs.homeManagerModules.default
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  home = {
    username = "ryanseipp";
    homeDirectory = "/Users/ryanseipp";

    shellAliases = {
      ls = "eza -l";
      la = "eza -la";
    };

    packages = with pkgs; [
      cilium-cli
      crane
      crossplane-cli
      cocoapods
      cosign
      dive
      docker
      docker-compose
      eza
      fd
      go
      gopls
      gofumpt
      golangci-lint
      govulncheck
      jq
      just
      kcl
      kclvm
      kclvm_cli
      kind
      kubectl
      kubectx
      librsvg
      opentofu
      pnpm
      ripgrep
      trivy
      slsa-verifier
      watchman
      yq-go
    ];

    stateVersion = "24.05";
  };

  btop.enable = true;
  yazi.enable = true;

  kitty = {
    enable = true;
    font = "Iosevka Nerd Font";
    fontSize = 12;
  };

  git = {
    enable = true;
    userName = "Ryan Seipp";
    userEmail = "rseipp@truefit.io";
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJuZUHaU60qbBM9wJkvihe0VWP7OXWpcEEEmP+EgBy0d ryanseipp@rseipp-MacBook-Pro";
  };

  programs = {
    k9s.enable = true;

    zsh.initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          host = "github.com";
          hostname = "ssh.github.com";
          port = 443;
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableNushellIntegration = false;
    };
  };
}
