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
      iosevka
      (iosevka.override { set = "Term"; })
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
    ];
  };
}
