{ ... }:
{
  flake.homeModules.kitty =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.kitty;
    in
    {
      options = {
        kitty.enable = lib.mkEnableOption "enable kitty";
        kitty.font = lib.mkOption {
          type = lib.types.str;
          default = "Iosevka";
          description = "Default kitty font";
        };
        kitty.fontSize = lib.mkOption {
          type = lib.types.number;
          default = 11;
          description = "Font size for kitty";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.kitty = {
          enable = true;
          package = if pkgs.stdenv.isDarwin then null else pkgs.kitty;
          font = lib.mkIf (cfg.font != null) {
            name = cfg.font;
            size = cfg.fontSize;
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

            "ctrl+shift+h" = "neighboring_window left";
            "ctrl+shift+l" = "neighboring_window right";
            "ctrl+shift+k" = "neighboring_window up";
            "ctrl+shift+j" = "neighboring_window down";

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
    };
}
