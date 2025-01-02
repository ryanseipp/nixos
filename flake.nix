{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    catppuccin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib;
    systems = ["x86_64-linux" "aarch64-darwin"];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    overlays = import ./overlays {inherit inputs;};
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosModules.default = ./modules/nixos;
    homeManagerModules.default = ./modules/homeManager;

    nixosConfigurations = {
      titan-r = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/titan-r
          self.nixosModules.default
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
        ];
        specialArgs = {inherit inputs outputs;};
      };
    };

    darwinConfigurations = {
      Ryan-Seipps-MBP = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = pkgsFor.aarch64-darwin;
        modules = [
          ./hosts/MacBook-Pro
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
        ];
        specialArgs = {inherit inputs outputs;};
      };
    };
  };
}
