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
      claude-code
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
      matchBlocks = {
        "vs-ssh.visualstudio.com" = {
          host = "vs-ssh.visualstudio.com";
          identityFile = "${homeDirectory}/.ssh/dlc_rsa";
          identitiesOnly = true;
        };
      };
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

    aerospace = {
      enable = true;
      launchd.enable = true;
      userSettings = {
        accordion-padding = 30;
        after-startup-command = [ ];
        automatically-unhide-macos-hidden-apps = true;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

        gaps = {
          outer = {
            left = 8;
            bottom = 8;
            top = 8;
            right = 8;
          };
          inner = {
            horizontal = 8;
            vertical = 8;
          };
        };

        mode.main.binding = {
          alt-f = "fullscreen";
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          ctrl-alt-shift-h = "join-with left";
          ctrl-alt-shift-j = "join-with down";
          ctrl-alt-shift-k = "join-with up";
          ctrl-alt-shift-l = "join-with right";

          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";
          alt-0 = "workspace 10";

          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
          alt-shift-0 = "move-node-to-workspace 10";

          alt-shift-c = "reload-config";

          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";

          alt-shift-semicolon = "mode service";
        };

        mode.service.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          r = [
            "flatten-workspace-tree"
            "mode main"
          ];
          f = [
            "layout floating tiling"
            "mode main"
          ];
          backspace = [
            "close-all-windows-but-current"
            "mode main"
          ];
        };

        workspace-to-monitor-force-assignment = {
          "1" = "main";
          "2" = "secondary";
          "3" = "main";
          "4" = "secondary";
          "5" = "main";
          "6" = "secondary";
          "7" = "main";
          "8" = "secondary";
          "9" = "main";
          "10" = "secondary";
        };
      };
    };
  };
  catppuccin.mako.enable = false;
}
