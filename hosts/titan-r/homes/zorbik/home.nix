{
  outputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {allowUnfree = true;};
  };

  home.username = "zorbik";
  home.homeDirectory = "/home/zorbik";
  home.packages = with pkgs; [
    curl
    eza
    fd
    hyprpaper
    ripgrep
    spotify
    vesktop
    wl-clipboard
  ];

  home.shellAliases = {
    ls = "eza -l";
    la = "eza -la";
  };

  git = {
    enable = true;
    userName = "Ryan Seipp";
    userEmail = "rseipp@ryanseipp.com";
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCycJpF3hp+BKw88FYMAfjhEtqC/1TkWqZjK1SScIVb rseipp@ryanseipp.com";
  };

  firefox.enable = true;
  hyprland.enable = true;
  kitty.enable = true;
  podman.enable = true;
  mako.enable = true;
  rofi.enable = true;
  waybar.enable = true;

  xdg = {
    enable = true;
    portal = {
      enable = true;
      config = {common.default = "*";};
      extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
  };
  programs.keychain = {
    enable = true;
    keys = ["id_rsa" "id_ed25519" "rseipp_id_ed25519"];
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    enableXsessionIntegration = false;
  };

  services.playerctld.enable = true;

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
