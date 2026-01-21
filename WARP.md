# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

Arch Linux dotfiles repository using GNU Stow for symlink management. Configured for Hyprland (Wayland compositor) with a modular installation system.

## Commands

### Installation
```bash
# Full system setup (installs packages + stows configs)
make install

# Remote bootstrap (clones repo and runs install)
curl -sL https://raw.githubusercontent.com/sergiocltn/dotfiles/main/boot.sh | bash
```

### Stow Management
```bash
# Stow config files (git, tmux, zsh, scripts, ghostty, starship, nvim)
make stow-config

# Stow Hyprland configs only
make stow-hyprland

# Remove stowed configs
make unstow-config
make uninstall
```

### Manual Stow (from config/)
```bash
cd config && stow git tmux zsh scripts ghostty starship
```

## Architecture

### Directory Structure
- `config/` — Stow packages for user dotfiles. Each subdirectory mirrors `$HOME` structure
- `hyprland/` — Hyprland-specific configs (waybar, mako, hypr), stowed to `~/.config/`
- `install/` — Modular installation scripts executed in phases

### Installation Phases
The `install.sh` runs scripts in order:
1. **preflight/** — Guards, environment setup, pacman config
2. **packaging/** — Package installation (base.sh for pacman, yay.sh for AUR)
3. **config/** — System configuration and stow operations
4. **login/** — Display manager (SDDM) and bootloader (Limine) setup
5. **post-install/** — Final cleanup and user prompts

### Helper System
- `run_logged` — Executes scripts with logging to `$DOTFILES_INSTALL_LOG_FILE`
- All install scripts are sourced, not executed, sharing environment variables
- Error handling via traps in `install/helpers/errors.sh`

### Package Lists
- `install/hyprland-base.packages` — Pacman packages (one per line)
- `install/hyprland-yay.packages` — AUR packages

### Stow Configuration
`.stowrc` configures stow with `--target=$HOME --no-folding` to prevent directory folding.

Neovim is handled specially (symlinked directly instead of stow) due to plugin requirements.
