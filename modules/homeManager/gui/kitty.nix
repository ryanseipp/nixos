{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.kitty;
in {
  options = {
    kitty.enable = mkEnableOption "enable kitty";
    kitty.font = mkOption {
      type = types.nullOr types.str;
      default = "Iosevka";
      description = "Default kitty font";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = mkIf (cfg.font != null) {
        name = cfg.font;
        size = 10;
      };
      shellIntegration.enableZshIntegration = true;

      settings = {
        background_opacity = "0.94";
      };
    };

    home.shellAliases = {
      ssh = "kitten ssh";
    };
  };
}
