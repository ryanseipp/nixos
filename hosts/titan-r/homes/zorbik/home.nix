{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    outputs.homeManagerModules.default
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    cursors = {
      enable = true;
      accent = "light";
    };
  };

  home = {
    username = "zorbik";
    homeDirectory = "/home/zorbik";

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
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCycJpF3hp+BKw88FYMAfjhEtqC/1TkWqZjK1SScIVb rseipp@ryanseipp.com";
  };

  btop.enable = true;
  firefox.enable = true;
  hyprland.enable = true;
  kitty.enable = true;
  ghostty.enable = true;
  podman.enable = true;
  mako.enable = true;
  rofi.enable = true;
  waybar.enable = true;
  yazi.enable = true;

  xdg = {
    enable = true;
    portal = {
      enable = true;
      config = {
        common.default = "*";
      };
      extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    };
  };

  programs = {
    home-manager.enable = true;

    zsh.initExtra = ''
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
      enable = true;
      keys = [
        "id_rsa"
        "id_ed25519"
        "rseipp_id_ed25519"
        "id_ed25519_sk"
      ];
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableNushellIntegration = false;
      enableXsessionIntegration = false;
    };
  };

  services.playerctld.enable = true;
}
