{
  lib,
  config,
  ...
}: {
  options = {zsh.enable = lib.mkEnableOption "enables zsh";};

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {path = "${config.xdg.dataHome}/zsh/zsh_history";};
    };
  };
}
