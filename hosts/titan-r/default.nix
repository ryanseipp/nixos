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

  programs.zsh.enable = true;
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  security.polkit.enable = true;

  desktop.enable = true;
  podmanHost.enable = true;
  # incusHost.enable = true;
  gc.enable = true;

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
    '';
  };

  systemd.coredump.enable = true;
  documentation = {
    enable = true;
    dev.enable = true;
    man.enable = true;
    info.enable = true;
    doc.enable = true;
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = ["pcie_port_pm=off"];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;

  hardware.graphics = {
    extraPackages = [pkgs.amdvlk];
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };

  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
