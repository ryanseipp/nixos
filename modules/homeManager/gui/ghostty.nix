{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.ghostty;
in
{
  options = {
    ghostty = {
      enable = mkEnableOption "enable ghostty";
      font = mkOption {
        type = types.str;
        default = "Iosevka";
        description = "Default ghostty font";
      };
      fontSize = mkOption {
        type = types.number;
        default = 11;
        description = "Default ghostty font size";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto-update = "off";

        theme = "catppuccin-mocha";
        background-opacity = 0.96;
        window-decoration = false;

        font-size = cfg.fontSize;
        font-family = cfg.font;
        font-family-italic = false;
        font-family-bold-italic = false;

        # freetype-load-flags = "no-hinting,no-autohint,no-force-autohint,no-monochrome";
      };
    };
  };
}
