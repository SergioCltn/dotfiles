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
- covers git, tmux, zsh, scripts, ghostty, starship, opencode
- replaces `~/.config/nvim` with the Neovim config from this repo

The opencode config expects `STITCH_API_KEY` and `WEALTHFOLIO_TOKEN` to be set
in your environment (`.zshrc` sources `~/.config/opencode/secrets.env` if present) for
the Stitch and Wealthfolio MCP servers.

On an existing machine with unmanaged opencode files, move
`~/.config/opencode/opencode.jsonc` and `~/.config/opencode/skills` aside before
running `make stow-config`, then copy any local-only values back into your
environment.

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

### Login screen (SDDM)

```bash path=null start=null
make sddm
```

- disables autologin and installs the `silent-minimal` theme: blurred wallpaper and a
  password field with only a cursor
- the theme is built from `sddm-silent-theme` with the overrides in
  `default/sddm/silent.conf.user`

The login screen is **not** stowed: the greeter runs before login as the `sddm` user and
can't read your home folder, so the theme and wallpaper are copied into
`/usr/share/sddm/themes/silent-minimal`. Rerun `make sddm` whenever you:

- edit `default/sddm/silent.conf.user`
- change `hyprland/.config/hypr/wallpaper.jpg`
- update the `sddm-silent-theme` package

Changes show up at the next logout or reboot. To preview without logging out:

```bash path=null start=null
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/silent-minimal
```

### First-run setup

```bash path=null start=null
make first-run
```

- symlinks resolv.conf (actually this looks like it's not needed it already is linked beforehand) 
- set up firewall ufw

### Shell extras

```bash path=null start=null
make shell-setup
```

- runs `install/shell-setup.sh`
- installs tmux plugin manager, oh-my-zsh, Zsh plugins, and sets Zsh as default shell (where supported)

### FIXES FOR T14
- F4 key stays light up all the time, for that alsamixer is needed, here is where it was solved https://github.com/alsa-project/alsa-ucm-conf/issues/100#issuecomment-1712564699
