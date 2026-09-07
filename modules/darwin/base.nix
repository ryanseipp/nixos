{ inputs, ... }:
{
  flake.darwinModules.base =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      nix = lib.mkIf config.nix.enable {
        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
        ];

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

        optimise.interval = {
          Minute = 10;
          Hour = 9;
          Weekday = 1;
        };

        gc = {
          options = "--delete-older-than 7d";
          interval = {
            Minute = 0;
            Hour = 9;
            Weekday = 1;
          };
        };
      };

      security.pam.services.sudo_local.touchIdAuth = true;

      fonts.packages = with pkgs; [
        inter
        source-sans
        nerd-fonts.iosevka
        nerd-fonts.sauce-code-pro
        nerd-fonts.caskaydia-mono
        nerd-fonts.symbols-only
      ];

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };
        global.autoUpdate = false;
      };

      system.defaults = {
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
