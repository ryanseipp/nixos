# NixOS Configuration

A rewrite of my old dotfiles configuration for use in NixOS, with home-manager.

## Bootstrapping

A nix shell is provided, so clone the repository, and
[install nix](https://nixos.org/download/). You can then enter the shell with

```sh
nix-shell
```

The following commands will setup everything on the system. Home-manager is
activated as a submodule of the system configuration, so these also rebuild
dotfiles and install user programs:

- `nixos-rebuild switch --flake ./#titan-r` - rebuild the OS (NixOS)
- `darwin-rebuild switch --flake ./#hyperion-r` - rebuild the system (macOS)

## Structure

Everything lives under `modules/`. `import-tree` loads every `.nix` file it
finds there, so adding a file is all it takes to register it — there is no
central import list. Paths beginning with `_` are skipped.

- `flake/` declares extra flake outputs and configures treefmt
- `home/` home-manager modules, split by category & program
- `nixos/` NixOS modules, split by category & program
- `darwin/` shared nix-darwin modules
- `users/` the per-user home-manager profile for each account
- `hosts/` one file per machine; `_hardware/` holds generated hardware config
