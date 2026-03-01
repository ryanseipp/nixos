{
  inputs,
  config,
  withSystem,
  ...
}:
let
  homeModules = config.flake.homeModules;
  nixosModules = config.flake.nixosModules;
in
{
  flake.nixosConfigurations.titan-r = withSystem "x86_64-linux" (
    { config, inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem rec {
      specialArgs = {
        inputs = removeAttrs inputs [ "self" ];
        inherit inputs';
        packages = config.packages;
      };
      modules =
        builtins.attrValues nixosModules
        ++ [
          inputs.hardware.nixosModules.common-cpu-amd
          inputs.hardware.nixosModules.common-cpu-amd-pstate
          inputs.hardware.nixosModules.common-gpu-amd
          inputs.hardware.nixosModules.common-pc-ssd
          inputs.catppuccin.nixosModules.catppuccin
          inputs.home-manager.nixosModules.home-manager
          ./_hardware/titan-r.nix
          (
            { pkgs, ... }:
            let
              kernel = pkgs.linuxKernel.packages.linux_6_12;
            in
            {
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
                  "docker"
                ];
              };

              nixpkgs.config.allowUnfree = true;
              environment.systemPackages =
                [
                  kernel.perf
                ]
                ++ (with pkgs; [
                  man-pages
                  man-pages-posix
                  liburing
                  networkmanagerapplet
                  winbox4
                  yubikey-manager
                  yubikey-personalization
                ]);

              programs = {
                _1password.enable = true;
                _1password-gui.enable = true;

                steam = {
                  enable = true;
                  extraCompatPackages = with pkgs; [
                    proton-ge-bin
                  ];
                };
              };

              desktop.enable = true;
              dockerHost.enable = true;
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

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.zorbik = {
                imports =
                  builtins.attrValues (removeAttrs homeModules [ "zorbik-darwin" "zorbik-linux" "ryanseipp" ])
                  ++ [
                    inputs.catppuccin.homeModules.catppuccin
                    homeModules.zorbik-linux
                  ];
              };
            }
          )
        ];
    }
  );
}
