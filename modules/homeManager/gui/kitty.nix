{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.kitty;
in
{
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

        # allow vim-kitty-navigator to focus windows
        allow_remote_control = "yes";
        listen_on = if pkgs.stdenv.isLinux then "unix:@mykitty" else "unix:/tmp/mykitty";
      };

      keybindings = {
        "ctrl+alt+k" = "launch --location=hsplit --cwd=current";
        "ctrl+alt+l" = "launch --location=vsplit --cwd=current";
        "ctrl+shift+r" = "layout_action rotate";

        "ctrl+shift+h" = "move_window left";
        "ctrl+shift+l" = "move_window right";
        "ctrl+shift+k" = "move_window up";
        "ctrl+shift+j" = "move_window down";

        "ctrl+h" = "kitten pass_keys.py left ctrl+h";
        "ctrl+l" = "kitten pass_keys.py right ctrl+l";
        "ctrl+k" = "kitten pass_keys.py top ctrl+k";
        "ctrl+j" = "kitten pass_keys.py bottom ctrl+j";

        "ctrl+cmd+l" = "next_tab";
        "ctrl+cmd+h" = "previous_tab";
      };
    };

    home.shellAliases = {
      ssh = "kitten ssh";
    };

    xdg.configFile."kitty/pass_keys.py" = {
      source = "${pkgs.vimPlugins.vim-kitty-navigator}/pass_keys.py";
    };
    xdg.configFile."kitty/get_layout.py" = {
      source = "${pkgs.vimPlugins.vim-kitty-navigator}/get_layout.py";
    };
  };
}
