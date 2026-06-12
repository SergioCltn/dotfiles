# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

export ZSH="$HOME/.oh-my-zsh"
export MEDIASMART_HOME="$HOME/Repositories/mediasmart/"

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

export PATH="/opt/homebrew/opt/mongodb-community@4.4/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# ============================================================================
# NVM (NODE VERSION MANAGER)
# ============================================================================


# ============================================================================
# OH-MY-ZSH CONFIGURATION
# ============================================================================

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
if [[ -s "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi


# ============================================================================
# INITS
# ============================================================================
if [[ "$(uname)" == "Darwin" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
elif [[ "$(uname)" == "Linux" ]] && command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
fi

# ============================================================================
# ALIASES
# ============================================================================

if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --long --icons --git'
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"


if command -v zoxide &> /dev/null; then
  alias cd="z"
fi

if [[ "$(uname)" == "Linux" ]]; then
    alias open="xdg-open"
fi

alias cat="bat"
alias grep="rg"
alias cp="cp -iv"
alias k="kubectl"

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

fzfpacman() { pacman -Sql | fzf --preview 'pacman -Si {}' \
      --preview-window=right:65%:wrap \
      --height 90% --layout=reverse --border; }

# ============================================================================
# FUNCTIONS
# ============================================================================
_nvim_socket_path() {
  local root digest

  root="$(git rev-parse --show-toplevel 2>/dev/null || pwd -P)"
  if command -v sha1sum &> /dev/null; then
    digest="$(printf '%s' "$root" | sha1sum | cut -d' ' -f1)"
  else
    digest="$(printf '%s' "$root" | shasum | cut -d' ' -f1)"
  fi

  printf '%s/nvim-%s.sock\n' "${XDG_RUNTIME_DIR:-/tmp}" "$digest"
}

unalias nvim 2>/dev/null
nvim() {
  command nvim --listen "$(_nvim_socket_path)" "$@"
}

compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

# ============================================================================
# HISTORY SETTINGS
# ============================================================================

HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt hist_ignore_space
setopt hist_reduce_blanks
