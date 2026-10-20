{ ... }:
{
  flake.homeModules.mako =
    { lib, config, ... }:
    {
      options = {
        mako.enable = lib.mkEnableOption "enables mako";
      };

      config = lib.mkIf config.mako.enable {
        services.mako = {
          enable = true;
          # Keys are written verbatim to mako's config; use mako's own names.
          settings = {
            default-timeout = 4000;
            font = "CaskaydiaMono Nerd Font 10";
            border-radius = 8;
            margin = "24,16,8,8";
          };
        };

        catppuccin.mako.enable = false;
      };
    };
}
