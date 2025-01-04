{
  lib,
  config,
  ...
}:
{
  options = {
    theme.enable = lib.mkEnableOption "enables the system theme";
  };

  config = lib.mkIf config.theme.enable {
    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
  };
}
