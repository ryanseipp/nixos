{
  pkgs,
  lib,
  config,
  ...
}:
let
in
# inherit (config.lib.formats.rasi) mkLiteral;
{
  options = {
    rofi.enable = lib.mkEnableOption "enables rofi";
  };

  config = lib.mkIf config.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      font = "Iosevka Nerd Font 9";
      terminal = "kitty";
      extraConfig = {
        combi-modes = [
          "run"
          "drun"
        ];
        modes = [
          "run"
          "drun"
          "combi"
        ];
        icon-theme = "Oranchelo";
        show-icons = true;
        drun-display-format = ''"{icon} {name}"'';
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;
      };
    };
  };
}
