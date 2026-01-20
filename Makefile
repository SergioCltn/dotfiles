.PHONY: install uninstall stow-config unstow-config stow-hyprland help

help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install        - Install all dependencies and stow dotfiles"
	@echo "  make uninstall      - Unstow all dotfiles"
	@echo "  make stow-config    - Stow config files (git, tmux, zsh, scripts, ghostty, nvim)"
	@echo "  make unstow-config  - Unstow config files only"
	@echo "  make stow-hyprland   - Stow Hyprland configuration only"

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
