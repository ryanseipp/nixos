{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:nixos/nixos-hardware";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcphub = {
      url = "github:ravitemer/mcp-hub";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    mcphub-nvim = {
      url = "github:ravitemer/mcphub.nvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, withSystem, ... }:
      {
        imports = [
          inputs.home-manager.flakeModules.home-manager
          inputs.treefmt-nix.flakeModule
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];
        flake = {
          nixosModules.ryanseipp = ./modules/nixos;
          homeModules.ryanseipp = ./modules/home;

          nixosConfigurations = {
            titan-r = withSystem "x86_64-linux" (
              { config, inputs', ... }:
              inputs.nixpkgs.lib.nixosSystem rec {
                specialArgs = {
                  inherit inputs inputs';
                  packages = config.packages;
                };
                modules = [
                  ./hosts/titan-r
                  self.nixosModules.ryanseipp
                  inputs.catppuccin.nixosModules.catppuccin
                  inputs.home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = specialArgs;
                    home-manager.users.zorbik = import ./homes/zorbik.nix;
                  }
                ];
              }
            );
          };

          darwinConfigurations = {
            Ryan-Seipps-MBP = withSystem "aarch64-darwin" (
              { config, inputs', ... }:
              inputs.darwin.lib.darwinSystem rec {
                specialArgs = {
                  inherit inputs inputs';
                  packages = config.packages;
                };
                modules = [
                  ./hosts/MacBook-Pro
                  inputs.home-manager.darwinModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = specialArgs;
                    home-manager.users.ryanseipp = import ./homes/ryanseipp.nix;
                  }
                ];
              }
            );

            "hyperion-r" = withSystem "aarch64-darwin" (
              { config, inputs', ... }:
              inputs.darwin.lib.darwinSystem rec {
                specialArgs = {
                  inherit inputs inputs';
                  packages = config.packages;
                };
                modules = [
                  ./hosts/hyperion-r
                  inputs.home-manager.darwinModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = specialArgs;
                    home-manager.users.ryanseipp = import ./homes/zorbik-mbp.nix;
                  }
                ];
              }
            );
          };
        };
      }
    );
}
