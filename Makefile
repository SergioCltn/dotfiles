.PHONY: install uninstall stow-config unstow-config stow-hyprland unstow-hyprland shell-setup help test-stow

help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install        - Install all dependencies and stow dotfiles"
	@echo "  make uninstall      - Unstow all dotfiles"
	@echo "  make stow-config    - Stow config files (git, tmux, zsh, scripts, ghostty, starship, opencode, nvim)"
	@echo "  make unstow-config  - Unstow config files only"
	@echo "  make stow-hyprland  - Stow Hyprland configuration only"
	@echo "  make shell-setup    - Install TPM, oh-my-zsh, plugins, set zsh as default"
	@echo "  make test-stow      - Test stow configurations for conflicts (dry-run)"

install:
	chmod +x install.sh
	./install.sh

uninstall:
	$(MAKE) unstow-config
	$(MAKE) unstow-hyprland

stow-config:
	cd config && stow git tmux zsh scripts ghostty starship opencode
	@if [ -e "$(HOME)/.config/nvim" ] && [ ! -L "$(HOME)/.config/nvim" ]; then \
		echo "Error: $(HOME)/.config/nvim exists and is not a symlink"; \
		echo "Move it aside before running make stow-config"; \
		exit 1; \
	fi
	@mkdir -p "$(HOME)/.config"
	rm -f "$(HOME)/.config/nvim"
	ln -s "$(PWD)/config/nvim/.config/nvim" "$(HOME)/.config/nvim"

unstow-config:
	cd config && stow -D git tmux zsh scripts ghostty starship opencode
	rm -f ~/.config/nvim

stow-hyprland:
	stow hyprland

unstow-hyprland:
	stow -D hyprland

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
	@cd config && { stow -n git tmux zsh scripts ghostty starship opencode 2>&1 | grep -v "in simulation mode" | grep -E "(CONFLICT|ERROR|cannot)" && { echo "✗ Stow conflicts detected!"; exit 1; } || echo "✓ No stow conflicts in config"; }
	@echo ""
	@echo "Testing hyprland/..."
	@{ stow -n hyprland 2>&1 | grep -v "in simulation mode" | grep -E "(CONFLICT|ERROR|cannot)" && { echo "✗ Stow conflicts detected!"; exit 1; } || echo "✓ No stow conflicts in hyprland"; }
	@echo ""
	@echo "All stow tests passed!"
