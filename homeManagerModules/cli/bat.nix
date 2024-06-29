{
  lib,
  config,
  ...
}: {
  options = {bat.enable = lib.mkEnableOption "enables bat";};

  config = lib.mkIf config.bat.enable {
    programs.bat.enable = true;

    programs.zsh = {
      sessionVariables = {
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        MANROFFOPT = "-c";
      };
    };
  };
}
