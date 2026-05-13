.PHONY: install uninstall stow-config unstow-config stow-hyprland shell-setup help test-stow

help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install        - Install all dependencies and stow dotfiles"
	@echo "  make uninstall      - Unstow all dotfiles"
	@echo "  make stow-config    - Stow config files (git, tmux, zsh, scripts, ghostty, nvim)"
	@echo "  make unstow-config  - Unstow config files only"
	@echo "  make stow-hyprland  - Stow Hyprland configuration only"
	@echo "  make shell-setup    - Install TPM, oh-my-zsh, plugins, set zsh as default"
	@echo "  make test-stow      - Test stow configurations for conflicts (dry-run)"

install:
	chmod +x install.sh
	./install.sh

uninstall:
	chmod +x uninstall.sh
	./uninstall.sh

stow-config:
	cd config && stow git tmux zsh scripts ghostty starship
	rm -rf ~/.config/nvim
	ln -sf $(PWD)/config/nvim/.config/nvim ~/.config/nvim

unstow-config:
	cd config && stow -D git tmux zsh scripts ghostty starship
	rm -f ~/.config/nvim

stow-hyprland:
	stow hyprland

setup-hibernate:
	./hyprland/.local/bin/hyprland-hibernate-setup

shell-setup:
	chmod +x install/shell-setup.sh
	./install/shell-setup.sh

first-run:
	./install/first-run/all.sh

test-stow:
	@echo "Testing stow configuration..."
	@which stow >/dev/null 2>&1 || { echo "Error: stow is not installed"; exit 1; }
	@echo "✓ stow is installed"
	@echo ""
	@echo "Testing config/..."
	@cd config && { stow -n git tmux zsh scripts ghostty starship 2>&1 | grep -v "in simulation mode" | grep -E "(CONFLICT|ERROR|cannot)" && { echo "✗ Stow conflicts detected!"; exit 1; } || echo "✓ No stow conflicts in config"; }
	@echo ""
	@echo "Testing hyprland/..."
	@{ stow -n hyprland 2>&1 | grep -v "in simulation mode" | grep -E "(CONFLICT|ERROR|cannot)" && { echo "✗ Stow conflicts detected!"; exit 1; } || echo "✓ No stow conflicts in hyprland"; }
	@echo ""
	@echo "All stow tests passed!"

