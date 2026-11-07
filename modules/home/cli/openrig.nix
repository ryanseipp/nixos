{ ... }:
{
  flake.homeModules.openrig =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.openrig;

      nodejs = pkgs.nodejs_22;

      # ── OpenRig: multi-agent rigs of claude-code / codex in tmux ──
      # Not in nixpkgs. Built from the published npm tarball, which ships
      # prebuilt dist/daemon/ui/tui; npm tarballs carry no lockfile, so one is
      # vendored in _openrig/ (regenerate with
      # `npm install --package-lock-only` in the unpacked tarball on bumps).
      openrig = pkgs.buildNpmPackage rec {
        pname = "openrig";
        version = "0.7.1";
        src = pkgs.fetchurl {
          url = "https://registry.npmjs.org/@openrig/cli/-/cli-${version}.tgz";
          hash = "sha256-wWN7viJFDzYYkCK7/N4jKItTdRlU+09rzgSWJ8uzdA8=";
        };
        sourceRoot = "package";
        postPatch = ''
          cp ${./_openrig/package-lock.json} package-lock.json
        '';
        npmDepsHash = "sha256-uvxw1vOoF52FHc/2boOxLgzKPWDjQTmWFTHP0J7abyc=";
        inherit nodejs;
        # better-sqlite3 ships N-API prebuilds; nothing to compile.
        dontNpmBuild = true;
      };
    in
    {
      options.openrig = {
        enable = lib.mkEnableOption "enables OpenRig";
        autostart = lib.mkEnableOption "starting the OpenRig daemon at login (Linux), restoring the rigs that were running";
      };

      config = lib.mkIf cfg.enable {
        # `rig start --last` boots the daemon (and kernel) and restores rigs
        # that were running, leaving rigs stopped on purpose down. The daemon
        # and its tmux server outlive this oneshot inside the unit's cgroup,
        # so stopping or changing the unit must never kill them: KillMode
        # limits a stop to the (already exited) launcher, and the unit is
        # never restarted by a switch. No ExecStop: stopping is not `rig down`.
        systemd.user.services.openrig = lib.mkIf (cfg.autostart && pkgs.stdenv.isLinux) {
          Unit = {
            Description = "OpenRig daemon, kernel and last-running rigs";
            After = [ "ssh-agent.service" ];
            X-SwitchMethod = "keep-old";
          };
          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            KillMode = "process";
            TimeoutStartSec = "5min";
            ExecStart = "${openrig}/bin/rig start --last";
            Environment = [
              "PATH=/run/wrappers/bin:/etc/profiles/per-user/${config.home.username}/bin:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin"
              "SSH_AUTH_SOCK=%t/ssh-agent"
            ];
          };
          Install.WantedBy = [ "default.target" ];
        };

        # tmux is a plain package rather than programs.tmux: `rig setup` owns a
        # managed block in ~/.tmux.conf. herdr is found by `rig setup` on PATH
        # instead of being curl-installed. nodejs goes on PATH because `rig
        # setup` writes Codex activity hooks into config.toml as bare `node`.
        home.packages = [
          openrig
          nodejs
          pkgs.tmux
          pkgs.herdr
        ];
      };
    };
}
