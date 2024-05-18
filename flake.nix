{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    hardware.url = "github:nixos/nixos-hardware";

    generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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
    nixpkgs-stable,
    home-manager,
    generators,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux"];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    pkgsForStable = lib.genAttrs systems (system:
      import nixpkgs-stable {
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
        modules = [./hosts/titan-r self.nixosModules.default];
        specialArgs = {inherit inputs outputs;};
      };
    };

    homeConfigurations = {
      "zorbik@titan-r" = lib.homeManagerConfiguration {
        modules = [./hosts/titan-r/homes/zorbik/home.nix self.homeManagerModules.default];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          pkgs-stable = pkgsForStable.x86_64-linux;
        };
      };
    };

    # virtual machine images
    packages = forEachSystem (pkgs: {
      k8s-system = generators.nixosGenerate {
        inherit pkgs;
        system = "x86_64-linux";
        format = "qcow-efi";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/k8s-system self.nixosModules.default];
      };
    });
  };
}
