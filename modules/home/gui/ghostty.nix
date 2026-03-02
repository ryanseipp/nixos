{ ... }:
{
  flake.homeModules.ghostty =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.ghostty;
    in
    {
      options = {
        ghostty.enable = lib.mkEnableOption "enable ghostty";
        ghostty.font = lib.mkOption {
          type = lib.types.str;
          default = "Iosevka";
          description = "Default ghostty font";
        };
        ghostty.fontSize = lib.mkOption {
          type = lib.types.number;
          default = 11;
          description = "Font size for ghostty";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.ghostty = {
          enable = true;
          package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;
          enableZshIntegration = true;

          settings = {
            font-family = cfg.font;
            font-size = cfg.fontSize;

            background-opacity = 0.96;
            macos-option-as-alt = true;

            keybind = [
              # Split creation (matching kitty's ctrl+alt+k/l)
              "ctrl+alt+k=new_split:down"
              "ctrl+alt+l=new_split:right"

              # Split navigation
              "ctrl+shift+h=goto_split:left"
              "ctrl+shift+j=goto_split:bottom"
              "ctrl+shift+k=goto_split:top"
              "ctrl+shift+l=goto_split:right"

              # Split management
              "ctrl+shift+z=toggle_split_zoom"
              "ctrl+shift+e=equalize_splits"

              # Tab navigation
              "ctrl+super+l=next_tab"
              "ctrl+super+h=previous_tab"
            ];
          };
        };
      };
    };
}
