{ ... }:
{
  flake.homeModules.gc-hm =
    { lib, config, ... }:
    {
      options = {
        gc-hm.enable = lib.mkEnableOption "enables nix gc for home manager";
      };

      config = lib.mkIf config.gc-hm.enable {
        nix.gc = {
          automatic = true;
          options = "--delete-older-than 7d";
        };
      };
    };
}
