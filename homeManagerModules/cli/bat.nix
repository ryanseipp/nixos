{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {bat.enable = lib.mkEnableOption "enables bat";};

  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      config = {theme = "Catppuccin Mocha";};
      themes = {
        "Catppuccin Mocha" = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
            sha256 = "1zlryg39y4dbrycjlp009vd7hx2yvn5zfb03a2vq426z78s7i423";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
    };

    programs.zsh = {
      sessionVariables = {
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        MANROFFOPT = "-c";
      };
    };
  };
}
