{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  fontFamily = "Inter";
  mkFont = (size: "${fontFamily} ${toString size}");
in
{
  options = {
    rofi.enable = lib.mkEnableOption "enables rofi";
  };

  config = lib.mkIf config.rofi.enable {
    home.packages = with pkgs; [ papirus-icon-theme ];

    catppuccin.rofi.enable = false;

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      font = mkFont (12);
      terminal = "kitty";
      extraConfig = {
        modes = [ "run" ];
        icon-theme = "Papirus";
        show-icons = true;
        display-run = "";
      };
      theme = {
        "*" = {
          font = mkFont 12;
          base = mkLiteral "#1e1e2ef2";
          surface0 = mkLiteral "#313244";
          surface1 = mkLiteral "#45475a";

          textColor = mkLiteral "#cdd6f4";
          red = mkLiteral "#f38ba8";
          overlay0 = mkLiteral "#6c7086";

          blue = mkLiteral "#89b4fa";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@textColor";

          margin = 0;
          padding = 0;
          spacing = 0;
        };

        window = {
          background-color = mkLiteral "@base";

          location = mkLiteral "north";
          y-offset = mkLiteral "calc(50% - 176px)";
          width = 640;
          border-radius = 8;
          border = mkLiteral "1px";
          border-color = mkLiteral "@blue";
        };

        inputbar = {
          font = mkFont 20;
          padding = mkLiteral "12px";
          spacing = mkLiteral "12px";
          children = map mkLiteral [
            "icon-search"
            "entry"
          ];
        };

        icon-search = {
          expand = false;
          filename = "search";
          size = mkLiteral "28px";
        };

        "icon-search, entry, element-icon, element-text" = {
          vertical-align = mkLiteral "0.5";
        };

        entry = {
          font = mkLiteral "inherit";

          placeholder = "Search";
          placeholder-color = mkLiteral "@overlay0";
        };

        message = {
          border = mkLiteral "2px 0 0";
          border-color = mkLiteral "@surface0";
          background-color = mkLiteral "@surface0";
        };

        textbox = {
          padding = mkLiteral "8px 24px";
        };

        listview = {
          lines = 10;
          columns = 1;

          fixed-height = false;
          border = mkLiteral "1px 0 0";
          border-color = mkLiteral "@surface0";
        };

        element = {
          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "16px";
          background-color = mkLiteral "transparent";
        };

        "element normal active" = {
          text-color = mkLiteral "@surface1";
        };

        "element alternate active" = {
          text-color = mkLiteral "@surface1";
        };

        "element selected normal, element selected active" = {
          background-color = mkLiteral "@surface1";
          text-color = mkLiteral "@red";
        };

        element-icon = {
          size = mkLiteral "1em";
        };

        element-text = {
          text-color = mkLiteral "inherit";
        };
      };
    };
  };
}
