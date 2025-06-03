{
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) self;
  homeDirectory = "/home/zorbik";
  defaultBrowser = "brave.desktop";
in
{
  imports = [
    self.homeModules.ryanseipp
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    cursors = {
      enable = true;
      accent = "light";
    };
    gtk.enable = true;
  };

  home = {
    username = "zorbik";
    inherit homeDirectory;

    preferXdgDirectories = true;

    shellAliases = {
      ls = "eza -l";
      la = "eza -la";
    };

    packages = with pkgs; [
      age
      bitwarden-desktop
      chromium
      curl
      dig
      ethtool
      eza
      fd
      gdb
      gimp
      hoppscotch
      hyprpaper
      lynis
      pavucontrol
      pulsemixer
      qalculate-qt
      qflipper
      ripgrep
      slack
      spotify
      sops
      ssh-to-age
      subnetcalc
      tidal-hifi
      vesktop
      wl-clipboard
    ];

    stateVersion = "23.11";
  };

  git = {
    enable = true;
    userName = "Ryan Seipp";
    userEmail = "rseipp@ryanseipp.com";
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRMSH0bp24l5UKhB+sUvevv4meZTjuwd7hYjBUhBSKV rseipp-signing-key";
    signingKeyPath = "${homeDirectory}/.ssh/rseipp_id_ed25519";
  };

  gc-hm.enable = true;
  brave.enable = true;
  btop.enable = true;
  hyprland.enable = true;
  kitty.enable = true;
  podman.enable = true;
  mako.enable = true;
  rofi.enable = true;
  waybar.enable = true;
  yazi.enable = true;
  lazygit.enable = true;

  xdg = {
    enable = true;
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
        "x-scheme-handler/discord" = "vesktop.desktop";
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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableNushellIntegration = false;
    };

    keychain = {
      enable = false;
      keys = [
        "rseipp_id_ed25519_sk"
        "rseipp_id_ed25519_sk2"
      ];
      enableZshIntegration = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableNushellIntegration = false;
      enableXsessionIntegration = false;
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      extraConfig = ''
        IdentityFile ${homeDirectory}/.ssh/rseipp_id_ed25519_sk
        IdentityFile ${homeDirectory}/.ssh/rseipp_id_ed25519_sk2
        IdentitiesOnly yes
      '';
    };
  };

  services = {
    ssh-agent.enable = true;
    playerctld.enable = true;
    trayscale.enable = true;
  };
}
