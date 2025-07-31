{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.zsh;
in
{
  options = {
    zsh.enable = mkEnableOption "enables zsh";
    zsh.enableFzf = mkEnableOption "enables fzf in zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      dotDir = "${config.xdg.configHome}/zsh";
      history.path = "${config.xdg.dataHome}/zsh/zsh_history";
      completionInit = "autoload -U compinit && compinit -d ${config.xdg.cacheHome}/zsh/zcompdump";

      initContent = ''
        autoload -U up-line-or-beginning-search
        autoload -U down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey "^[[A" up-line-or-beginning-search
        bindkey "^[[B" down-line-or-beginning-search
      '';

      envExtra = with config; ''
        export CARGO_HOME=${xdg.dataHome}/cargo
        export DOTNET_CLI_HOME=${xdg.dataHome}/dotnet
        export NUGET_PACKAGES=${xdg.cacheHome}/NuGetPackages
        export MIX_XDG="true"
        export NPM_CONFIG_USERCONFIG=${xdg.configHome}/npm/npmrc
        export OMNISHARPHOME=${xdg.configHome}/omnisharp
        export PYTHON_HISTORY=${xdg.stateHome}/python/history
        export PYTHONPYCACHEPREFIX=${xdg.cacheHome}/python
        export PYTHONUSERBASE=${xdg.dataHome}/python
        export RUSTUP_HOME=${xdg.dataHome}/rustup
        export GOPATH=${xdg.dataHome}/go
        export GOMODCACHE=${xdg.cacheHome}/go/mod
      '';
    };

    programs.fzf = mkIf cfg.enableFzf {
      enable = true;
      enableZshIntegration = true;
    };

    xdg.configFile."npm/npmrc" = {
      enable = true;
      text = with config; ''
        prefix=${xdg.dataHome}/npm
        cache=${xdg.cacheHome}/npm
        init-module=${xdg.configHome}/npm/config/npm-init.js
        logs-dir=${xdg.stateHome}/npm/logs
      '';
    };
  };
}
