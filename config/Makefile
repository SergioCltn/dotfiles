.PHONY: install uninstall stow unstow help

help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install    - Install all dependencies and stow dotfiles"
	@echo "  make uninstall  - Unstow all dotfiles"
	@echo "  make stow       - Stow dotfiles only (no dependency installation)"
	@echo "  make unstow     - Unstow dotfiles only"

install:
	@chmod +x install.sh
	@./install.sh

uninstall:
	@chmod +x uninstall.sh
	@./uninstall.sh

stow:
	@stow git tmux zsh scripts ghostty
	@rm -rf ~/.config/nvim
	@ln -sf $(PWD)/nvim/.config/nvim ~/.config/nvim

unstow:
	@stow -D git tmux zsh scripts ghostty
	@rm -f ~/.config/nvim
