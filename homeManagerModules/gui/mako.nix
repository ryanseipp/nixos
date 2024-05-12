{
  lib,
  config,
  ...
}: {
  options = {mako.enable = lib.mkEnableOption "enables mako";};

  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;
      defaultTimeout = 3000;
      font = "Iosevka Nerd Font 10";
      backgroundColor = "#1e1e2e";
      textColor = "#cdd6f4";
      borderColor = "#89b4fa";
      progressColor = "over #313244";

      extraConfig = ''
        [urgency=high]
        borderColor=#fab387
      '';
    };
  };
}
