#!/bin/bash

# Shell Setup: TPM, oh-my-zsh, plugins, and default shell

set -e

echo "=== Installing Tmux Plugin Manager (TPM) ==="
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "TPM installed"
else
  echo "TPM already installed"
fi

echo ""
echo "=== Installing oh-my-zsh ==="
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "oh-my-zsh installed"
else
  echo "oh-my-zsh already installed"
fi

echo ""
echo "=== Installing zsh plugins ==="
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ "$(uname)" == "Darwin" ]]; then
  # macOS - install via Homebrew
  if command -v brew &>/dev/null; then
    brew install zsh-syntax-highlighting zsh-autosuggestions 2>/dev/null || true
  fi
  
  # Symlink to oh-my-zsh custom plugins
  [ -d /opt/homebrew/share/zsh-syntax-highlighting ] && \
    ln -sf /opt/homebrew/share/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  [ -d /opt/homebrew/share/zsh-autosuggestions ] && \
    ln -sf /opt/homebrew/share/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

elif [[ "$(uname)" == "Linux" ]]; then
  # Arch Linux - install via pacman
  if command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm --needed zsh-syntax-highlighting zsh-autosuggestions
  fi
  
  # Symlink to oh-my-zsh custom plugins
  [ -d /usr/share/zsh/plugins/zsh-syntax-highlighting ] && \
    ln -sf /usr/share/zsh/plugins/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  [ -d /usr/share/zsh/plugins/zsh-autosuggestions ] && \
    ln -sf /usr/share/zsh/plugins/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
echo "Plugins installed"

echo ""
echo "=== Setting zsh as default shell ==="
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
  echo "Default shell changed to zsh (will take effect on next login)"
else
  echo "zsh is already the default shell"
fi

echo ""
echo "=== Shell setup complete ==="
