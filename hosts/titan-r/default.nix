{
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  kernel = pkgs.linuxKernel.packages.linux_6_12;
in
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "titan-r";
    domain = "home.ryanseipp.local";
    networkmanager.enable = true;
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  users.users.zorbik = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
  home-manager.users.zorbik = import ./homes/zorbik/home.nix { inherit pkgs inputs outputs; };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    [ kernel.perf ]
    ++ (with pkgs; [
      man-pages
      man-pages-posix
      liburing
      networkmanagerapplet
      winbox4
      yubikey-manager
      yubikey-personalization
      yubikey-personalization-gui
    ]);

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };

  desktop.enable = true;
  podmanHost.enable = true;
  gc.enable = true;

  boot = {
    kernelParams = [ "pcie_port_pm=off" ];
    kernelPackages = kernel;

    binfmt.emulatedSystems = [
      "aarch64-linux"
      "riscv64-linux"
    ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    graphics = {
      extraPackages = [ pkgs.amdvlk ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };

    flipperzero.enable = true;
  };

  system.stateVersion = "23.11";
}
