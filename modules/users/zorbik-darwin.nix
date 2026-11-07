{ ... }:
let
  homeDirectory = "/Users/zorbik";
in
{
  # macOS-specific half of the zorbik profile; see zorbik-common.nix.
  flake.homeProfiles.zorbik-darwin =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      # home-manager's nh module appends clean.extraArgs to the launchd
      # ProgramArguments as ONE string (no shell to split it), so nh would see
      # a single bogus argument. Split it ourselves.
      launchd.agents.nh-clean.config.ProgramArguments = lib.mkForce (
        [
          (lib.getExe config.programs.nh.package)
          "clean"
          "user"
        ]
        ++ lib.splitString " " config.programs.nh.clean.extraArgs
      );

      home = {
        inherit homeDirectory;

        packages = with pkgs; [
          graalvmPackages.graalvm-ce
          mosh
          poppler-utils
          yubikey-manager
          yubikey-personalization
        ];

        stateVersion = "25.11";
      };

      mcp.github.pat = "op://Dev/GitHub PAT - Claude Code MCP/credential";

      ghostty = {
        enable = true;
        fontSize = 14;
      };

      aerospace = {
        enable = true;
        floatingAppIds = [ "com.mitchellh.ghostty" ];
      };

      git = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3zMo59N1hukphn9i0jvSdUN9ng3AmaP22gYbzk5HOK zorbik@hyperion-r.local";
        signingKeyPath = "${homeDirectory}/.ssh/id_ed25519";
      };

      programs = {
        # Determinate Nixd handles disk-pressure GC; nh prunes old generations
        # of this user's profiles on a schedule (launchd agent).
        nh = {
          enable = true;
          darwinFlake = "${homeDirectory}/nixos";
          clean = {
            enable = true;
            dates = "weekly";
            extraArgs = "--keep-since 7d --keep 5";
          };
        };

        zsh.initContent = ''
          eval "$(/opt/homebrew/bin/brew shellenv)"

          # eval $(/opt/homebrew/bin/ssh-agent)
          # export SSH_ASKPASS=/usr/local/bin/ssh-askpass
          # export DISPLAY=":0"
        '';

        ssh.settings."*" = {
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

        # Remote dev box over the tailnet (Tailscale SSH; MagicDNS name).
        # `mosh titan-r -- tmux new -As rig` for the long-lived session.
        ssh.settings."titan-r" = {
          User = "zorbik";
          ServerAliveInterval = 30;
        };
      };
    };
}
