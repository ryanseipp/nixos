{
  lib,
  config,
  ...
}:
{
  options = {
    mako.enable = lib.mkEnableOption "enables mako";
  };

  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;
      defaultTimeout = 3000;
      font = "Iosevka Nerd Font 10";
    };
  };
}
