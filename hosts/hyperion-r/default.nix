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
    enable = true;
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
      "kitty"
      "proton-mail"
      "spotify"
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
    computerName = "hyperion-r";
    hostName = "hyperion-r";
    localHostName = "hyperion-r";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = with pkgs; [
    inter
    source-sans
    nerd-fonts.iosevka
    nerd-fonts.sauce-code-pro
    nerd-fonts.symbols-only
  ];

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
          { app = "/Applications/kitty.app"; }
          { app = "/Applications/Brave Browser.app"; }
          { app = "/Applications/1Password.app"; }
          { app = "/Applications/Spotify.app"; }
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
