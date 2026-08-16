{...}: {
  flake.nixosModules.base = {
    pkgs,
    inputs,
    ...
  }: let
    cloudflareNameservers = [
      # "2606:4700:4700::1111"
      # "2606:4700:4700::1001"
      "8.8.8.8"
      "1.1.1.1"
    ];
  in {
    nix = {
      package = pkgs.nix;
      nixPath = let
        path = toString ./../..;
      in [
        "nixpkgs=${inputs.nixpkgs}"
        "nixos-config=${path}"
      ];
      channel.enable = false;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = ["https://claude-code.cachix.org"];
        trusted-public-keys = [
          "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
        ];
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
