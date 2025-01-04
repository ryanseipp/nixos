{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    prettyFonts.enable = lib.mkEnableOption "enable custom fonts";
  };

  config = lib.mkIf config.prettyFonts.enable {
    fonts.packages = with pkgs; [
      inter
      source-sans
      nerd-fonts.iosevka
      nerd-fonts.sauce-code-pro
    ];
  };
}
