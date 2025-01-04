{
  lib,
  config,
  ...
}:
{
  options = {
    gc.enable = lib.mkEnableOption "enables nix gc";
  };

  config = lib.mkIf config.gc.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nix.optimise.automatic = true;
  };
}
