{
  lib,
  config,
  ...
}: {
  options = {
    zsh.enable = lib.mkEnableOption "enables zsh";
    zsh.enableFzf = lib.mkEnableOption "enables fzf in zsh";
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {path = "${config.xdg.dataHome}/zsh/zsh_history";};

      initExtra = ''
        autoload -U up-line-or-beginning-search
        autoload -U down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey "''${key[Up]}" up-line-or-beginning-search
        bindkey "''${key[Down]}" down-line-or-beginning-search
      '';
    };

    programs.fzf = lib.mkIf config.zsh.enableFzf {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
