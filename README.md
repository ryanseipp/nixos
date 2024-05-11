# NixOS Configuration

A rewrite of my old dotfiles configuration for use in NixOS, with home-manager.

## Bootstrapping

A nix shell is provided, so clone the repository, and
[install nix](https://nixos.org/download/). You can then enter the shell with

```sh
nix-shell
```

The following commands will setup everything on the system:

- `nixos-rebuild switch --flake ./#titan-r` - rebuild the OS (if using NixOS)
- `home-manager switch --flake ./#zorbik@titan-r` - rebuild dotfiles and install
  programs

## Structure

- `hosts/<hostname>` contains configuration for all systems running NixOS
  - `homes/<username>` contains the home-manager module for each user on the
    host
- `homeManagerModules` contains home-manager modules split by category & program
- `overlays` currently just patches `pkgs` to provide access to flake inputs
