{ ... }:
{
  flake.nixosModules.desktop =
    { lib, config, ... }:
    {
      options = {
        desktop.enable = lib.mkEnableOption "enables default desktop experience";
      };

      config = lib.mkIf config.desktop.enable {
        sddm.enable = true;
        audio.enable = true;
        bluetooth.enable = true;
        prettyFonts.enable = true;
        theme.enable = true;
      };
    };
}
