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
        background_opacity = "0.96";
        enabled_layouts = "splits:split_axis=horizontal";
      };

      keybindings = {
        "ctrl+alt+k" = "launch --location=hsplit --cwd=current";
        "ctrl+alt+l" = "launch --location=vsplit --cwd=current";
        "ctrl+shift+r" = "layout_action rotate";

        "ctrl+shift+h" = "move_window left";
        "ctrl+shift+l" = "move_window right";
        "ctrl+shift+k" = "move_window up";
        "ctrl+shift+j" = "move_window down";

        "ctrl+h" = "neighboring_window left";
        "ctrl+l" = "neighboring_window right";
        "ctrl+k" = "neighboring_window up";
        "ctrl+j" = "neighboring_window down";

        "ctrl+cmd+l" = "next_tab";
        "ctrl+cmd+h" = "previous_tab";
      };
    };

    home.shellAliases = {
      ssh = "kitten ssh";
    };
  };
}
