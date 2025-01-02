{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  nix = {
    package = pkgs.nix;
    nixPath = let
      path = toString ./../..;
    in [
      "nixpkgs=${inputs.nixpkgs}"
      "nixos-config=${path}"
    ];

    channel.enable = false;
    settings.experimental-features = ["nix-command" "flakes"];

    optimise.automatic = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  users.users.ryanseipp = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };
  home-manager.users.ryanseipp = import ./homes/ryanseipp/home.nix {inherit pkgs inputs outputs;};

  homebrew = {
    enable = true;
    brews = [
      "azure-cli"
      "docker"
      "docker-credential-helper"
      "gnu-sed"
      "yarn"
    ];
    casks = [
      "android-studio"
      "dbeaver-community"
      "kitty"
      "tidal"
      "netnewswire"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };

  environment.systemPackages = with pkgs; [
    android-tools
    nodejs_22
  ];

  fonts.packages = with pkgs; [
    inter
    source-sans
    nerd-fonts.iosevka
    nerd-fonts.sauce-code-pro
    nerd-fonts.symbols-only
  ];

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  system.stateVersion = 4;
}