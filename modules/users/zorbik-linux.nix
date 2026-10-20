{ ... }:
let
  homeDirectory = "/home/zorbik";
  defaultBrowser = "zen-beta.desktop";
in
{
  # Linux-specific half of the zorbik profile; see zorbik-common.nix.
  flake.homeProfiles.zorbik-linux =
    { pkgs, ... }:
    {
      catppuccin.cursors = {
        enable = true;
        accent = "light";
      };

      home = {
        inherit homeDirectory;

        packages = with pkgs; [
          # System utilities
          age
          awscli2
          curl
          dig
          ethtool
          gdb
          sops
          ssh-to-age
          unzip
          wl-clipboard

          # Desktop apps
          chromium
          discord
          gimp
          hoppscotch
          hyprpaper
          lynis
          pavucontrol
          proton-pass
          protonmail-desktop
          pulsemixer
          qalculate-qt
          qFlipper
          slack
          spotify
          tidal-hifi
          zoom-us
        ];

        stateVersion = "23.11";
      };

      git = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRMSH0bp24l5UKhB+sUvevv4meZTjuwd7hYjBUhBSKV rseipp-signing-key";
        signingKeyPath = "${homeDirectory}/.ssh/rseipp_id_ed25519";
      };

      ghostty = {
        enable = true;
        fontSize = 12;
      };
      hyprland.enable = true;
      mako.enable = true;
      rofi.enable = true;
      waybar.enable = true;

      xdg = {
        portal = {
          enable = true;
          config = {
            common.default = "*";
          };
          extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
        };
        mimeApps = {
          enable = true;
          defaultApplications = {
            "text/html" = defaultBrowser;
            "application/pdf" = defaultBrowser;
            "x-scheme-handler/http" = defaultBrowser;
            "x-scheme-handler/https" = defaultBrowser;
            "x-scheme-handler/about" = defaultBrowser;
            "x-scheme-handler/unknown" = defaultBrowser;
            "x-scheme-handler/ror2mm" = "r2modman.desktop";
            "x-scheme-handler/discord" = "discord.desktop";
          };
        };
      };

      programs = {
        home-manager.enable = true;

        zsh.initContent = ''
          analyze_dump () {
            dump=$1
            info=$(coredumpctl info "$dump")
            exe=$(echo "$info" | rg 'Executable' | awk '{print $2}')

            echo INFO:
            echo
            coredumpctl dump "$dump" --output "$dump.core"
            echo
            echo Dropping into debugger...
            echo
            gdb "$exe" -c "$dump.core"
          }
        '';

        ssh.settings."*" = {
          AddKeysToAgent = "yes";
          IdentityFile = [
            "${homeDirectory}/.ssh/rseipp_id_ed25519_sk"
            "${homeDirectory}/.ssh/rseipp_id_ed25519_sk2"
          ];
          IdentitiesOnly = "yes";
        };
      };

      services = {
        ssh-agent.enable = true;
        playerctld.enable = true;
        trayscale.enable = true;
      };
    };
}
