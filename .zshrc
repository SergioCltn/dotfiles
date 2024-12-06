# env used for dev_env scripts
export DEV_ENV_HOME=~/dotfiles

# Enable Powerlevel11k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ZSH="$HOME/.oh-my-zsh"
export MEDIASMART_HOME="$HOME/Repositories"
export XDG_CONFIG_HOME="$HOME/.config"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions mediasmart-frontend)
source $ZSH/oh-my-zsh.sh

alias air=$(go env GOPATH)/bin/air

export PATH="/opt/homebrew/opt/mongodb-community@4.4/bin:$PATH"



HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=2000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

eval "$(zoxide init zsh)"
alias cd="z"

alias ls="eza --icons=always"


# alias zmk="/Users/sergiogonzalezsicilia/.local/pipx/venvs/zmk/bin/zmk"
# bindkey '^[[A' history-search-backward
# bindkey '^[[B' history-search-forward

# PATH=~/.console-ninja/.bin:$PATH

# Created by `pipx` on 2024-09-22 23:09:26
export PATH="$PATH:/Users/sergiogonzalezsicilia/.local/bin"

# Use C-r to find for commands
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
