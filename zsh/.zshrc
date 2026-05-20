export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="jbergantine"
zstyle ':omz:update' frequency 7

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd/mm/yyyy"

plugins=(
  git
  fzf
  rust
  vi-mode
)
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
# Docker CLI completions (only if Docker Desktop is installed)
[ -d "$HOME/.docker/completions" ] && fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit
compinit

source <(COMPLETE=zsh muxx)
source <(fzf --zsh)

# aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias cd="z"
alias pls="sudo"
alias x="clear"
alias vim="nvim"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -f /usr/local/spear-dev-tools/runconfig.sh ] && source /usr/local/spear-dev-tools/runconfig.sh

# Default AWS profile
export AWS_PROFILE=personal

export PATH="$HOME/.local/bin:$PATH"
EDITOR=nvim

# bun completions
[ -s "/Users/harsh.sandhu/.bun/_bun" ] && source "/Users/harsh.sandhu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Zoxide with fzf
zi() {
  local dir
  dir=$(zoxide query -l | head -50 | fzf --preview 'ls -la {}') && z "$dir"
 }

# Claude Code
alias cc='claude'
alias ccr='claude --resume'
function ccp() { claude --print "$@" }

# pnpm
export PNPM_HOME="/Users/harsh.sandhu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

eval "$(zoxide init zsh)"
