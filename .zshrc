# ============================================================================
# POWERLEVEL10K INSTANT PROMPT
# ============================================================================
# Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input must go above this block.

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

export DEV_ENV_HOME=~/dotfiles
export ZSH="$HOME/.oh-my-zsh"
export MEDIASMART_HOME="$HOME/Repositories"
export XDG_CONFIG_HOME="$HOME/.config"

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

export PATH="/opt/homebrew/opt/mongodb-community@4.4/bin:$PATH"
export PATH="$PATH:/Users/sergiogonzalezsicilia/.local/bin"

# ============================================================================
# NVM (NODE VERSION MANAGER)
# ============================================================================
# Must be loaded before Oh-My-Zsh plugins that depend on it

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ============================================================================
# OH-MY-ZSH CONFIGURATION
# ============================================================================

# Enable completion system
autoload -Uz compinit
compinit

plugins=(git zsh-syntax-highlighting zsh-autosuggestions mediasmart-frontend)
source $ZSH/oh-my-zsh.sh

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

# ============================================================================
# SHELL OPTIONS
# ============================================================================

setopt noclobber          # Prevent overwriting files with > (use >! to override)
setopt correct            # Suggest corrections for mistyped commands

# ============================================================================
# FZF CONFIGURATION
# ============================================================================

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# FZF theme colors
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# Use fd instead of find
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Preview settings
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# FZF completion customization
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# FZF Git integration
source ~/fzf-git.sh/fzf-git.sh

# ============================================================================
# ZOXIDE (BETTER CD)
# ============================================================================

eval "$(zoxide init zsh)"

# ============================================================================
# RIPGREP (BETTER GREP)
# ============================================================================

# Set default options for ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Replace grep with ripgrep
alias grep="rg"

# ============================================================================
# ALIASES
# ============================================================================

# Modern replacements
alias ls="eza --icons=always"
alias cat="bat"
alias cd="z"

# Utilities
alias cp="cp -iv"
alias k="kubectl"
alias nvim="nvim --listen ./nvim.sock"

# Platform-specific
if [[ "$(uname)" == "Linux" ]]; then
    alias open="xdg-open"
fi
