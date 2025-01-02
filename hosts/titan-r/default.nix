{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "titan-r";
    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
    };
  };

  users.users.zorbik = {
    isNormalUser = true;
    extraGroups = ["wheel" "incus-admin" "networkmanager"];
    shell = pkgs.zsh;
  };
  home-manager.users.zorbik = import ./homes/zorbik/home.nix {inherit pkgs inputs outputs;};

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    r2modman
    liburing
    networkmanagerapplet
  ];

  programs = {
    zsh.enable = true;

    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    ssh = {
      startAgent = true;
      extraConfig = ''
        Host *
          AddKeysToAgent yes
      '';
    };
  };
  security.polkit.enable = true;

  desktop.enable = true;
  podmanHost.enable = true;
  # incusHost.enable = true;
  gc.enable = true;

  systemd.coredump.enable = true;
  documentation = {
    enable = true;
    dev.enable = true;
    man.enable = true;
    info.enable = true;
    doc.enable = true;
  };

  boot = {
    kernelParams = ["pcie_port_pm=off"];
    kernelPackages = pkgs.linuxKernel.packages.linux_6_12;

    binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    graphics = {
      extraPackages = [pkgs.amdvlk];
      extraPackages32 = [pkgs.driversi686Linux.amdvlk];
    };

    flipperzero.enable = true;
  };

  system.stateVersion = "23.11";
}
