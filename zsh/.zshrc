export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' frequency 7

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd/mm/yyyy"

plugins=(git)
source $ZSH/oh-my-zsh.sh

# User configuration
#
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/harsh.sandhu/.docker/completions $fpath)
autoload -Uz compinit
compinit

eval "$(zoxide init zsh)"
source <(COMPLETE=zsh muxx)

# aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias pls="sudo"
alias x="clear"
alias vim="nvim"

# Flutter Path
export PATH=$HOME/development/flutter/bin:$PATH
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /usr/local/spear-dev-tools/runconfig.sh

# Default AWS profile
export AWS_PROFILE=personal

export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "/Users/harsh.sandhu/.bun/_bun" ] && source "/Users/harsh.sandhu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
