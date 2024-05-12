{lib, ...}: {
  imports = [
    ./bat.nix
    ./git.nix
    ./neovim.nix
    ./podman.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
  ];

  bat.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
}
