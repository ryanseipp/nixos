{
  inputs,
  config,
  withSystem,
  ...
}: let
  homeModules = config.flake.homeModules;
  nixosModules = config.flake.nixosModules;
in {
  flake.nixosConfigurations.titan-r = withSystem "x86_64-linux" (
    {
      config,
      inputs',
      ...
    }:
      inputs.nixpkgs.lib.nixosSystem rec {
        specialArgs = {
          inputs = removeAttrs inputs ["self"];
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
              {pkgs, ...}: let
                kernel = pkgs.linuxKernel.packages.linux_7_1;
              in {
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
                    pkgs.perf
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
                  _1password-gui = {
                    enable = true;
                    polkitPolicyOwners = ["zorbik"];
                  };

                  steam = {
                    enable = true;
                    extraCompatPackages = with pkgs; [
                      proton-ge-bin
                    ];
                  };
                };

                # Trust Zen so the 1Password app exposes its native-messaging host to it.
                environment.etc."1password/custom_allowed_browsers" = {
                  text = ''
                    .zen-beta-wrapped
                    .zen-wrapped
                  '';
                  mode = "0755";
                };

                desktop.enable = true;
                dockerHost.enable = true;
                gc.enable = true;

                boot = {
                  kernelParams = [
                    # MT7922 wifi/BT and Intel I225-V ethernet on this board (ASUS X670E-F)
                    # both misbehave with PCIe power management. Disable ASPM globally and
                    # belt-and-suspenders at the mt7921e driver level.
                    "pcie_port_pm=off"
                    "pcie_aspm=off"
                    "mt7921e.disable_aspm=1"
                    "mem_sleep_default=deep" # Use S3 deep sleep for stable AMD suspend
                  ];
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
                  graphics.enable = true;
                  flipperzero.enable = true;
                };

                system.stateVersion = "23.11";

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                # Back up (rather than fail on) pre-existing unmanaged dotfiles when
                # Home Manager starts managing them — e.g. Zen's own profiles.ini.
                home-manager.backupFileExtension = "hm-bak";
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users.zorbik = {
                  imports =
                    builtins.attrValues (
                      removeAttrs homeModules [
                        "zorbik-darwin"
                        "zorbik-linux"
                        "ryanseipp"
                      ]
                    )
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
