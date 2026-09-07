{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.flake = {
    darwinConfigurations = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = "Darwin system configurations";
    };

    darwinModules = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = "Reusable nix-darwin modules";
    };

    homeProfiles = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = ''
        Per-user home-manager profiles. Kept separate from `homeModules` so
        hosts can import every feature module wholesale without also pulling
        in other users' profiles.
      '';
    };
  };
}
