{ inputs, ... }:
{
  flake.homeModules.zen-browser =
    {
      pkgs,
      lib,
      config,
      inputs',
      ...
    }:
    let
      cfg = config.zen-browser;
    in
    {
      options = {
        zen-browser.enable = lib.mkEnableOption "enables the Zen browser";
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ inputs'.zen-browser.packages.default ];
      };
    };
}
