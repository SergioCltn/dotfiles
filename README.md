# Dotfiles

Simple notes on how to use this repo and the `Makefile`.

## Install everything

From the repo root:

```bash path=null start=null
make install
```

This runs `install.sh`, which:
- installs required packages (system + AUR)
- applies system config
- sets up all dotfiles using GNU Stow

## Manage configs with make

All commands below are run from the repo root.

### Stow configs

```bash path=null start=null
make stow-config
```

- symlinks dotfiles from `config/` into your `$HOME`
- covers git, tmux, zsh, scripts, ghostty, starship
- replaces `~/.config/nvim` with the Neovim config from this repo

### Unstow configs

```bash path=null start=null
make unstow-config
```

- removes the symlinks created by `make stow-config`
- removes the Neovim symlink at `~/.config/nvim`

### Hyprland setup

```bash path=null start=null
make stow-hyprland
```

- symlinks everything under `hyprland/` into your home
- sets up Hyprland, Waybar, mako, and the helper scripts in `~/.local/bin`

### Shell extras

```bash path=null start=null
make shell-setup
```

- runs `install/shell-setup.sh`
- installs tmux plugin manager, oh-my-zsh, Zsh plugins, and sets Zsh as default shell (where supported)
