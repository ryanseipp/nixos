{
  pkgs,
  inputs,
  outputs,
  ...
}:
{
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  nix = {
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
      automatic = true;
      interval = {
        Minute = 10;
        Hour = 9;
        Weekday = 1;
      };
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      interval = {
        Minute = 0;
        Hour = 9;
        Weekday = 1;
      };
    };
  };

  users.users.ryanseipp = {
    home = "/Users/ryanseipp";
    isHidden = false;
    shell = pkgs.zsh;
  };
  home-manager.users.ryanseipp = import ./homes/ryanseipp/home.nix { inherit pkgs inputs outputs; };

  homebrew = {
    enable = true;
    brews = [
      "azure-cli"
      "gnu-sed"
      "helm"
      "libfido2"
      "openssh"
      "yarn"
      "kcl-lang/tap/kcl-lsp"
    ];
    casks = [
      "brave-browser"
      "kitty"
      "spotify"
      "tidal"
      "netnewswire"
    ];
    taps = [
      { name = "kcl-lang/tap"; }
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    global = {
      autoUpdate = false;
    };
  };

  networking = {
    computerName = "Ryan Seipp's MBP";
    hostName = "Ryan-Seipps-MBP";
    localHostName = "Ryan-Seipps-MBP";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = with pkgs; [
    android-tools
    nodejs_24
    postgresql
  ];

  fonts.packages = with pkgs; [
    inter
    source-sans
    nerd-fonts.iosevka
    nerd-fonts.sauce-code-pro
    nerd-fonts.symbols-only
  ];

  programs.zsh.enable = true;

  system = {
    stateVersion = 4;
    primaryUser = "ryanseipp";
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
          { app = "/Applications/kitty.app"; }
          { app = "/Applications/Brave Browser.app"; }
          { app = "/Applications/Slack.app"; }
          { app = "/Applications/1Password.app"; }
          { app = "/Applications/TIDAL.app"; }
          { app = "/Applications/NetNewsWire.app"; }
          { app = "/Applications/Docker.app/Contents/MacOS/Docker Desktop.app"; }
          { app = "/Applications/Azure VPN Client.app"; }
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
