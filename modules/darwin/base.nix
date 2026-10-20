{ ... }:
{
  flake.darwinModules.base =
    { pkgs, ... }:
    {
      # Nix itself (daemon, nix.conf, GC) is managed by Determinate Nix via
      # `determinateNix.*` in the host config, not by nix-darwin's `nix.*`.
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
        # Keep activation fast and deterministic: no network on every
        # `darwin-rebuild switch`. Run `brew update && brew upgrade` by hand.
        # "uninstall" removes formulae/casks not in the Brewfile but keeps
        # their app data (unlike "zap").
        onActivation = {
          autoUpdate = false;
          upgrade = false;
          cleanup = "uninstall";
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
