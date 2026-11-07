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

        # catppuccin's cursors module drives home.pointerCursor; relying on
        # that implicitly is deprecated, so opt in explicitly
        pointerCursor.enable = true;

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
      mpv.enable = true;
      # titan-r holds the always-on OpenRig kernel; bring it back after reboots.
      openrig.autostart = true;
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

        # Non-FIDO key so pushes work over mosh and from unattended agents
        # while the YubiKey is away from this machine; sk keys as fallback.
        ssh.settings."github.com" = {
          IdentityFile = [
            "${homeDirectory}/.ssh/titan-r_github_ed25519"
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
