{lib, ...}: {
  imports = [
    ./bat.nix
    ./btop.nix
    ./git.nix
    ./lazygit.nix
    ./neovim.nix
    ./podman.nix
    ./starship.nix
    ./tmux.nix
    ./yazi.nix
    ./zsh.nix
  ];

  bat.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  zsh.enableFzf = lib.mkDefault true;
}
