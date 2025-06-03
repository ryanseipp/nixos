{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.git;
in
{
  options = {
    git.enable = lib.mkEnableOption "enables git";

    git.userName = lib.mkOption {
      type = lib.types.str;
      example = "Ryan Seipp";
    };

    git.userEmail = lib.mkOption {
      type = lib.types.str;
      example = "myEmail@example.com";
    };

    git.signingKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "SSH key to sign commits with";
      example = "ssh-ed25519 <ssh-key-public-hash> comment";
      default = null;
    };

    git.signingKeyPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Path to SSH key used for commit signing.
        Necessary to preload a signing key protected by a password into the ssh-agent.
      '';
      example = "ssh-ed25519 <ssh-key-public-hash> comment";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      g = "git";
      gbm = ''g br --merged | rg -v "(^\*|main|master|develop)" | xargs g brd'';
    };

    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };

    programs.git = {
      enable = true;

      userName = cfg.userName;
      userEmail = cfg.userEmail;

      aliases = {
        a = "add";
        br = "branch";
        brd = "branch -d";
        brl = "branch -l";
        c = "commit";
        cm = "commit -m";
        co = "checkout";
        cob = "checkout -b";
        com = "checkout main";
        conf = "config";
        d = "diff";
        ds = "diff --staged";
        m = "merge";
        new = "log origin.. --reverse";
        lg = "log --graph --all --pretty=format:'%C(yellow)%h%Creset %C(cyan)%an%Creset -%C(magenta)%d%Creset %s %Cgreen(%cr)%Creset'";
        lgs = "log --graph --all --pretty=format:'%C(yellow)%h%Creset %C(cyan)%an [%G?]%Creset -%C(magenta)%d%Creset %s %Cgreen(%cr)%Creset'";
        p = "pull -p";
        pu = "push";
        puf = "push --force-with-lease";
        rb = "rebase";
        rba = "rebase --abort";
        rbc = "rebase --continue";
        rs = "restore";
        rss = "restore --staged";
        st = "status";
      };

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        merge.autoStash = true;
        rebase.autoStash = true;
        log.abbrevCommit = true;
        help.autoCorrect = "immediate";
        diff.tool = "nvimdiff";
        gpg = (
          lib.mkIf (cfg.signingKey != null) {
            ssh = {
              allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
            };
          }
        );
      };

      signing = lib.mkIf (cfg.signingKey != null) {
        key = cfg.signingKey;
        signByDefault = true;
        format = "ssh";
        signer = "${config.home.homeDirectory}/.ssh/preload-signing-key.sh";
      };
    };

    home.file.".ssh/allowed_signers" = {
      enable = cfg.signingKey != null;
      text = ''${cfg.userEmail} namespaces="git" ${cfg.signingKey}'';
    };

    home.file.".ssh/preload-signing-key.sh" = {
      enable = cfg.signingKeyPath != null;
      executable = true;
      source = pkgs.writeShellScript "preload-signing-key.sh" ''
        set -euo pipefail
        ssh-add -T ${cfg.signingKeyPath} 2>&- || ssh-add ${cfg.signingKeyPath}
        exec ${lib.getExe' pkgs.openssh "ssh-keygen"} "$@"
      '';
    };
  };
}
