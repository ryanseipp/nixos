{
  lib,
  config,
  ...
}:
{
  options = {
    gc-hm.enable = lib.mkEnableOption "enables nix gc for home manager";
  };

  config = lib.mkIf config.gc-hm.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
