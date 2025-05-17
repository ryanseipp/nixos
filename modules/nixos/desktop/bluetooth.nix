{
  lib,
  config,
  ...
}:
{
  options = {
    bluetooth.enable = lib.mkEnableOption "enables bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {
    services.blueman.enable = true;
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
    };
  };
}
