{
  lib,
  config,
  ...
}:
{
  options = {
    audio.enable = lib.mkEnableOption "enables desktop audio";
  };

  config = lib.mkIf config.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
    };

    services.pulseaudio.extraClientConf = ''
      cookie-file = ~/.config/pulse/cookie
    '';
  };
}
