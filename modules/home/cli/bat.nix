{
  lib,
  config,
  ...
}:
{
  options = {
    bat.enable = lib.mkEnableOption "enables bat";
  };

  config = lib.mkIf config.bat.enable {
    programs.bat.enable = true;

    programs.zsh = {
      envExtra = ''
        MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
        MANROFFOPT="-c"
      '';
    };
  };
}
