# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Repository Overview

This is a NixOS/nix-darwin configuration repository using Nix Flakes and
home-manager for dotfiles management. It supports both NixOS (Linux) and
nix-darwin (macOS) systems with a unified configuration approach.

## Common Commands

### Development Environment

- `nix-shell` - Enter development shell with required tools (nix, home-manager,
  git)
- `nix flake show` - Display all available flake outputs and configurations

### System Management

- `nixos-rebuild switch --flake ./#titan-r` - Rebuild NixOS system (Linux host:
  titan-r)
- `darwin-rebuild switch --flake ./#hyperion-r` - Rebuild macOS system (macOS
  host: hyperion-r)

There are no `homeConfigurations` outputs. Home-manager is activated as a
submodule of each system configuration, so the two commands above are the only
way to apply user configuration.

### Code Formatting

- `nix fmt` - Format all Nix files using treefmt (nixfmt, prettier)
- `nix flake check` - Validate flake and run formatting checks

## Architecture

This is a **dendritic** flake-parts configuration. `flake.nix` holds nothing but
inputs and a two-line `imports`; every output is produced by a file under
`modules/`, which `import-tree` discovers automatically. Adding a file is enough
to register it — there is no central import list. Files and directories whose
name starts with `_` are skipped, which is how `modules/hosts/_hardware/` stays
out of the tree.

Each module file's job is to register an attribute:

- `modules/home/**` → `flake.homeModules.<name>`
- `modules/nixos/**` → `flake.nixosModules.<name>`
- `modules/darwin/**` → `flake.darwinModules.<name>`
- `modules/users/*.nix` → `flake.homeProfiles.<name>` (per-user profiles, kept
  out of `homeModules` so hosts can import every feature module wholesale)
- `modules/hosts/*.nix` → `flake.nixosConfigurations.*` /
  `flake.darwinConfigurations.*`

`flake.darwinConfigurations`, `flake.darwinModules` and `flake.homeProfiles` are
not flake-parts built-ins; they are declared in `modules/flake/outputs.nix`.

**The most important thing to know before editing:** hosts import _every_ module
— `builtins.attrValues nixosModules`, `builtins.attrValues homeModules` — and
select behaviour via each module's own `enable` option. A new module is
therefore inert until some host or profile sets `<name>.enable = true`, and a
module's `config` must be wrapped in `lib.mkIf` or it will apply everywhere.

Current machines:

- `titan-r` - NixOS desktop (AMD hardware, gaming setup), user `zorbik-linux`
- `hyperion-r` - macOS (Apple Silicon, development setup), user `zorbik-darwin`

### Key Technologies

- **Nix Flakes** - Reproducible configuration management
- **home-manager** - User environment and dotfiles management
- **nix-darwin** - macOS system configuration
- **Catppuccin** - Consistent theming across applications
- **flake-parts** + **import-tree** - Flake organization and composition

### Module System

The configuration uses a modular approach where functionality is split into
focused modules:

- CLI tools (neovim, git, zsh, etc.) in `modules/home/cli/`
- GUI applications (ghostty, browsers, etc.) in `modules/home/gui/`
- System services and hardware in `modules/nixos/`
- Shared macOS system defaults in `modules/darwin/`

### Special Features

- **Cross-platform support** - Same user configuration works on both NixOS and
  macOS
- **Catppuccin theming** - Consistent dark theme across all applications
- **Development tools** - Kubernetes tools, Docker, language toolchains
  pre-configured
- **Security** - YubiKey support, 1Password integration, TouchID authentication
  on macOS
