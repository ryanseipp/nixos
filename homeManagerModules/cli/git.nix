{ lib, config, ... }:
let cfg = config.git;
in {
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
    };
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.shellAliases = {
        g = "git";
        gbm = ''g br --merged | rg -v "(^\*|master|main)" | xargs g brd'';
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
          plog = "log --graph --all --decorate --oneline";
          p = "pull -p";
          pu = "push";
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
          commit.gpgsign = true;
          diff.tool = "nvimdiff";
        };
      };
    }

    (lib.mkIf (cfg.signingKey != null) {
      programs.git = {
        signing = {
          key = cfg.signingKey;
          signByDefault = true;
        };

        extraConfig = {
          gpg.format = "ssh";
          ssh = {
            allowedSignersFile =
              "${config.home.homeDirectory}/.ssh/allowed_signers";
          };
        };
      };

      home.file.".ssh/allowed_signers" = {
        enable = true;
        text = ''${cfg.userEmail} namespaces="git" ${cfg.signingKey}'';
      };
    })
  ]);
}
