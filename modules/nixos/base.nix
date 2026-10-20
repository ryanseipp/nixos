{ ... }: {
  flake.nixosModules.base =
    { ... }:
    let
      cloudflareNameservers = [
        # "2606:4700:4700::1111"
        # "2606:4700:4700::1001"
        "8.8.8.8"
        "1.1.1.1"
      ];
    in
    {
      # NIX_PATH (nixpkgs=flake:nixpkgs) and the nixpkgs registry entry come
      # from `nixpkgs.flake.*`, which lib.nixosSystem sets up automatically.
      nix = {
        channel.enable = false;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          substituters = [ "https://claude-code.cachix.org" ];
          trusted-public-keys = [
            "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
          ];
        };
        optimise.automatic = true;
      };

      # nh clean replaces nix.gc: it also prunes user profiles and stale
      # `result` gcroots, and keeps a minimum number of generations.
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep-since 7d --keep 5";
        };
      };

      services = {
        fstrim.enable = true;
        nscd.enableNsncd = false;
        resolved = {
          enable = true;
          settings.Resolve = {
            DNSSEC = "true";
            DNSOverTLS = "true";
          };
        };

        # Power management - fallback suspend on idle
        logind.settings.Login = {
          HandleLidSwitch = "suspend";
          HandlePowerKey = "suspend";
          IdleAction = "suspend";
          IdleActionSec = "20min";
        };
      };

      security.polkit.enable = true;
      systemd.coredump.enable = true;
      documentation = {
        enable = true;
        dev.enable = true;
        man.enable = true;
        info.enable = true;
        doc.enable = true;
      };

      networking = {
        nftables.enable = true;
        firewall.enable = true;
        nameservers = cloudflareNameservers;
        networkmanager.insertNameservers = cloudflareNameservers;
      };

      time.timeZone = "America/New_York";
      i18n.defaultLocale = "en_US.UTF-8";

      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      programs = {
        zsh.enable = true;
        nix-ld.enable = true;
        git.enable = true;
        # We never use nano; disabling it also removes its EDITOR=nano default.
        nano.enable = false;
      };
    };
}
