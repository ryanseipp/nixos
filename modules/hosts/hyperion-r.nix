{ inputs, config, ... }:
let
  homeModules = config.flake.homeModules;
  homeProfiles = config.flake.homeProfiles;
  darwinModules = config.flake.darwinModules;
  specialArgs = {
    inputs = removeAttrs inputs [ "self" ];
  };
in
{
  flake.darwinConfigurations.hyperion-r = inputs.darwin.lib.darwinSystem {
    inherit specialArgs;
    modules = [
      inputs.home-manager.darwinModules.home-manager
      darwinModules.base
      (
        { pkgs, ... }:
        {
          nixpkgs = {
            hostPlatform = "aarch64-darwin";
            config.allowUnfree = true;
            overlays = [
              (_final: prev: {
                direnv = prev.direnv.overrideAttrs (_: {
                  doCheck = false;
                });
              })
            ];
          };

          # Nix is managed outside of nix-darwin on this host.
          nix.enable = false;

          users.users.zorbik = {
            home = "/Users/zorbik";
            isHidden = false;
            shell = pkgs.zsh;
          };

          homebrew = {
            brews = [
              "gnu-sed"
              "libfido2"
              "openssh"
            ];
            casks = [
              "1password"
              "balenaetcher"
              "claude"
              "docker-desktop"
              "ghostty"
              "libreoffice"
              "proton-drive"
              "proton-mail"
              "slack"
              "spotify"
              "tailscale-app"
              "winbox"
              "wireshark-app"
              "discord"
              "zen"
            ];
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

          services.tailscale.enable = true;

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
            _1password.enable = true;
            zsh.enable = true;
          };

          system = {
            stateVersion = 6;
            primaryUser = "zorbik";
            defaults.dock.persistent-apps = [
              { app = "/Applications/Zen.app"; }
              { app = "/Applications/Ghostty.app"; }
              { app = "/Applications/Claude.app"; }
              { app = "/Applications/Discord.app"; }
              { app = "/Applications/Proton Mail.app"; }
              { app = "/Applications/Spotify.app"; }
              { app = "/Applications/1Password.app"; }
              { app = "/System/Applications/System Settings.app"; }
              { spacer.small = true; }
            ];
          };

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.zorbik = {
            imports = builtins.attrValues homeModules ++ [
              inputs.catppuccin.homeModules.catppuccin
              homeProfiles.zorbik-darwin
            ];
          };
        }
      )
    ];
  };
}
