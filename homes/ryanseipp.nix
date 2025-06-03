{
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs) self;
  homeDirectory = "/Users/ryanseipp";
in
{
  imports = [
    self.homeModules.ryanseipp
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  home = {
    username = "ryanseipp";
    inherit homeDirectory;
    preferXdgDirectories = true;

    shellAliases = {
      ls = "eza -l";
      la = "eza -la";
    };

    sessionVariables = {
      JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home";
      ANDROID_HOME = "${homeDirectory}/Library/Android/sdk";
    };

    sessionPath = [
      "\${ANDROID_HOME}/emulator"
      "\${ANDROID_HOME}/platform-tools"
    ];

    packages = with pkgs; [
      act
      cilium-cli
      crane
      cocoapods
      cosign
      devbox
      dive
      docker
      docker-compose
      eas-cli
      eza
      fd
      gh
      git-filter-repo
      jq
      just
      kcl
      kind
      kubectl
      kubectl-tree
      kubectl-cnpg
      kubectx
      librsvg
      opentofu
      pnpm
      ripgrep
      trivy
      slsa-verifier
      subnetcalc
      watchman
      yubikey-manager
      yubikey-personalization
      yq-go
    ];

    stateVersion = "24.05";
  };

  gc-hm.enable = true;
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
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8HLVTAaUeBJmSVZ2+E1cJdgFA4AI0dbCTFbvA8ymOt rseipp@truefit.io-signing";
    signingKeyPath = "${homeDirectory}/.ssh/rseipp_ed25519";
  };

  programs = {
    k9s.enable = true;
    lazygit.enable = true;

    zsh.initContent = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"

      eval $(/opt/homebrew/bin/ssh-agent)
      export SSH_ASKPASS=/usr/local/bin/ssh-askpass
      export DISPLAY=":0"
    '';

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      extraConfig = ''
        IdentityFile ${homeDirectory}/.ssh/rseipp_ed25519_sk
        IdentityFile ${homeDirectory}/.ssh/rseipp_ed25519_sk2
        IdentitiesOnly yes
      '';
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableNushellIntegration = false;
    };
  };
  catppuccin.mako.enable = false;
}
