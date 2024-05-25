{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
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

    nixosModules.default = ./nixosModules;
    homeManagerModules.default = ./homeManagerModules;

    nixosConfigurations = {
      titan-r = lib.nixosSystem {
        system = "x64_64-linux";
        modules = [
          ./hosts/titan-r
          self.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
        specialArgs = {inherit inputs outputs;};
      };
    };
  };
}
