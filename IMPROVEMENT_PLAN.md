# Dotfiles Improvement Plan

## Priority 1: Fix Broken Runtime Behavior

- [x] Fix `make uninstall` in `Makefile`.
  - Either add a real `uninstall.sh` or replace the target with existing `unstow-config` and Hyprland unstow commands.
- [x] Stop `make stow-config` from deleting `~/.config/nvim` with `rm -rf`.
  - Prefer stowing `nvim` normally or moving an existing config to a timestamped backup.
- [x] Fix undefined `log_info` in `install/post-install/font-setup.sh`.
  - Replace with `echo`, define `log_info`, or source a logging helper that provides it.
- [x] Restore mkinitcpio hooks reliably if installation fails.
  - Add cleanup logic/traps immediately after `install/preflight/disable-mkinitcpio.sh` disables hooks.
- [x] Fix `DOTFILES_PATH` defaults in hibernation scripts.
  - Remove the extra `}` in `hyprland/.local/bin/hyprland-hibernate-setup` and `hyprland/.local/bin/hyprland-hibernate-remove`.
- [x] Fix Waybar screen recording command.
  - Change `hyprland-cmd-screenrecord` to the existing `hyprland-screenrecord`, or add a wrapper with the expected name.
- [x] Fix the shebang in `hyprland/.local/bin/hyprland-launch-tui`.
  - The shebang must be the first line of the file.
- [ ] Resolve `make test-stow` conflicts for opencode.
  - Move/adopt unmanaged files under `~/.config/opencode`, or document a safe migration command.
  - Status: blocked on deciding how to handle existing files outside this repo.

## Priority 2: Improve Safety And Security

- [x] Avoid world-writable install logs.
  - Replace `chmod 666` in `install/helpers/logging.sh` with safer ownership and `600` or `644` permissions.
- [ ] Make temporary sudoers permissions safer.
  - Narrow `install/preflight/first-run-mode.sh` command aliases and ensure cleanup runs on failure.
- [x] Review global Git `protocol.file.allow = always`.
  - Remove it or reduce it to a safer setting unless it is required globally.
- [x] Make `remove_untracked_files` safer in `config/git/.githelpers`.
  - Prefer `git clean -fdn` before deletion, or use `git clean -fd` intentionally.
- [ ] Reduce direct edits to system files.
  - Use drop-in config files where possible and create backups before `sed -i` edits.

## Priority 3: Improve Portability And Idempotency

- [x] Stop hard-coding `~/dotfiles`.
  - Derive the repo path from `BASH_SOURCE[0]` in `install.sh`, `install/first-run/all.sh`, and retry paths.
- [ ] Make repeated installs idempotent.
  - Avoid repeated appends, especially in `install/config/ssh-flakiness.sh`.
- [ ] Split package lists by role or hardware.
  - Keep base packages separate from hardware-specific packages like Broadcom drivers.
- [ ] Quote shell variables consistently.
  - Focus on paths and command arguments in installer scripts and Hyprland helpers.
- [ ] Avoid `eval` in `hyprland-launch-or-focus`.
  - Use explicit command arguments or arrays instead.

## Priority 4: Add Checks And Tooling

- [ ] Add a `make check` target.
  - Include `bash -n`, `shellcheck`, `shfmt`, `stylua`, and config validation where practical.
- [ ] Add `shellcheck` to the package list.
  - This allows local validation of shell scripts.
- [ ] Keep `make test-stow` non-destructive and reliable.
  - Ensure it passes on a machine after following documented setup steps.

## Priority 5: Clean Up Dotfile Hygiene

- [ ] Replace the upstream Kickstart Neovim README.
  - Document this repo's actual Neovim layout, dependencies, and common commands.
- [ ] Decide whether to track `lazy-lock.json`.
  - Track it for reproducibility or remove it from Git if it should be ignored.
- [x] Guard optional Zsh integrations.
  - Check for oh-my-zsh and `fzf` before sourcing/evaluating them.
- [x] Remove hard-coded personal paths from `.zshrc`.
  - Use `$HOME` and only export Android/Java paths when they exist.
- [x] Avoid creating `nvim.sock` in arbitrary working directories.
  - Use a stable socket path under `$XDG_RUNTIME_DIR` or another runtime directory.

## Priority 6: Small Neovim Fixes

- [ ] Fix duplicate DAP `<F2>` mapping in `debug.lua`.
  - Assign separate keys for step-into and step-over.
- [ ] Remove duplicate `bash` from Treesitter parser list.
- [ ] Fix the tab-width comment in `options.lua`.
  - The comment says 4, but the config sets 2.
