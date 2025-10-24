# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS/nix-darwin configuration repository using Nix Flakes and home-manager for dotfiles management. It supports both NixOS (Linux) and nix-darwin (macOS) systems with a unified configuration approach.

## Common Commands

### Development Environment
- `nix-shell` - Enter development shell with required tools (nix, home-manager, git)
- `nix flake show` - Display all available flake outputs and configurations

### System Management
- `nixos-rebuild switch --flake ./#titan-r` - Rebuild NixOS system (Linux host: titan-r)
- `darwin-rebuild switch --flake ./#hyperion-r` - Rebuild macOS system (macOS host: hyperion-r)
- `home-manager switch --flake ./#zorbik@titan-r` - Apply home-manager configuration for Linux
- `home-manager switch --flake ./#zorbik@hyperion-r` - Apply home-manager configuration for macOS

### Code Formatting
- `nix fmt` - Format all Nix files using treefmt (nixfmt, stylua, prettier)
- `nix flake check` - Validate flake and run formatting checks

## Architecture

### Configuration Structure
- **`flake.nix`** - Main flake entry point defining inputs, outputs, and system configurations
- **`hosts/`** - Host-specific configurations:
  - `titan-r/` - NixOS desktop system (AMD hardware, gaming setup)
  - `hyperion-r/` - macOS system (Apple Silicon, development setup)
  - `MacBook-Pro/` - Alternative macOS configuration
- **`homes/`** - User-specific home-manager configurations:
  - `zorbik.nix` - Linux user configuration
  - `zorbik-mbp.nix` - macOS user configuration
  - `ryanseipp.nix` - Alternative user configuration
  - `common.nix` - Shared user configuration
- **`modules/`** - Reusable configuration modules:
  - `home/` - Home-manager modules (CLI tools, GUI apps, development setup)
  - `nixos/` - NixOS system modules (desktop, server, virtualization)

### Key Technologies
- **Nix Flakes** - Reproducible configuration management
- **home-manager** - User environment and dotfiles management
- **nix-darwin** - macOS system configuration
- **Catppuccin** - Consistent theming across applications
- **flake-parts** - Flake organization and composition

### Host Configurations
- **titan-r** (NixOS): AMD desktop with gaming support, Docker, desktop environment
- **hyperion-r** (macOS): Development machine with Homebrew integration, tiling WM (Aerospace)

### Module System
The configuration uses a modular approach where functionality is split into focused modules:
- CLI tools (neovim, git, zsh, etc.) in `modules/home/cli/`
- GUI applications (kitty, browsers, etc.) in `modules/home/gui/`
- System services and hardware in `modules/nixos/`

### Special Features
- **Cross-platform support** - Same user configuration works on both NixOS and macOS
- **Catppuccin theming** - Consistent dark theme across all applications
- **Development tools** - Kubernetes tools, Docker, language toolchains pre-configured
- **Security** - YubiKey support, 1Password integration, TouchID authentication on macOS