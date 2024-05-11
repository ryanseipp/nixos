{ pkgs, lib, config, ... }: {
  options = { tmux.enable = lib.mkEnableOption "enables tmux"; };
  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;

      prefix = "C-Space";
      keyMode = "vi";
      mouse = true;

      baseIndex = 1;

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_window_default_text "#W"
            set -g @catppuccin_window_current_text "#W"
            set -g @catppuccin_status_modules_right "directory session"
          '';
        }
        vim-tmux-navigator
        yank
      ];

      extraConfig = ''
        set-option -sa terminal-features ',xterm-kitty:RGB'

        # Shift arrow to switch windows
        bind -n S-Left previous-window
        bind -n S-Right next-window

        # Shift alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';
    };
  };
}
