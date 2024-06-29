{
  lib,
  config,
  ...
}: {
  options = {kitty.enable = lib.mkEnableOption "enable kitty";};

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka";
        size = 10;
      };
      shellIntegration.enableZshIntegration = true;

      settings = {
        background_opacity = "0.94";
      };
    };
  };
}
