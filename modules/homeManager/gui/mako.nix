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
      defaultTimeout = 4000;
      font = "Iosevka Nerd Font 10";
      borderRadius = 8;
      margin = "24,16,8,8";
    };

    catppuccin.mako.accent = "blue";
  };
}
