{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

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
    home-manager,
    catppuccin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib;
    systems = ["x86_64-linux"];
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
      virt-host = lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = let
        in [
          ./hosts/virt-host
          self.nixosModules.default
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
        ];
        specialArgs = {inherit inputs outputs;};
      };
    };
  };
}
