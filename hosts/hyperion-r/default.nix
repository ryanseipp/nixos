{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  nix = {
    enable = false;
    package = pkgs.nix;
    nixPath =
      let
        path = toString ./../..;
      in
      [
        "nixpkgs=${inputs.nixpkgs}"
        "nixos-config=${path}"
      ];

    channel.enable = false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    optimise = {
      automatic = false;
      interval = {
        Minute = 10;
        Hour = 9;
        Weekday = 1;
      };
    };

    gc = {
      automatic = false;
      options = "--delete-older-than 7d";
      interval = {
        Minute = 0;
        Hour = 9;
        Weekday = 1;
      };
    };
  };

  users.users.zorbik = {
    home = "/Users/zorbik";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    brews = [
      "gnu-sed"
      "libfido2"
      "openssh"
    ];
    casks = [
      "1password"
      "brave-browser"
      "claude"
      "docker-desktop"
      "kitty"
      "proton-mail"
      "slack"
      "spotify"
      "tailscale-app"
      "vesktop"
      "zen"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    global = {
      autoUpdate = false;
    };
  };

  networking = {
    computerName = "hyperion-r";
    hostName = "hyperion-r";
    localHostName = "hyperion-r";

    applicationFirewall = {
      enable = true;
      enableStealthMode = false;
      allowSigned = true;
      allowSignedApp = true;
      blockAllIncoming = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  services.tailscale.enable = true;

  fonts.packages = with pkgs; [
    inter
    source-sans
    nerd-fonts.iosevka
    nerd-fonts.sauce-code-pro
    nerd-fonts.caskaydia-mono
    nerd-fonts.symbols-only
  ];

  environment = {
    systemPackages = with pkgs; [
      jdk21_headless
      jdk17_headless
    ];
    shellAliases = {
      java21 = "${pkgs.jdk21_headless}/bin/java";
      java17 = "${pkgs.jdk17_headless}/bin/java";
    };
    variables = {
      JAVA_HOME = "${pkgs.jdk21_headless}";
    };
  };

  programs = {
    zsh.enable = true;
  };

  system = {
    stateVersion = 6;
    primaryUser = "zorbik";
    defaults = {
      ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
      ActivityMonitor.IconType = 5;
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };
      controlcenter = {
        AirDrop = false;
        BatteryShowPercentage = true;
        Bluetooth = true;
        Display = false;
        FocusModes = false;
        NowPlaying = true;
        Sound = true;
      };
      dock = {
        autohide = true;
        mru-spaces = false;
        orientation = "bottom";
        persistent-apps = [
          { app = "/Applications/Zen.app"; }
          { app = "/Applications/kitty.app"; }
          { app = "/Applications/Claude.app"; }
          { app = "/Applications/Vesktop.app"; }
          { app = "/Applications/Proton Mail.app"; }
          { app = "/Applications/Spotify.app"; }
          { app = "/Applications/1Password.app"; }
          { app = "/System/Applications/System Settings.app"; }
          { spacer.small = true; }
        ];
        show-recents = false;
      };
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nslv";
        FXRemoveOldTrashItems = true;
        ShowPathbar = true;
        _FXSortFoldersFirst = true;
      };
    };
  };
}
