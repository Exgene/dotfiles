export EDITOR="nvim"

eval "$(starship init zsh)"

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey '^ ' autosuggest-accept
export ZSH_SYSTEM_CLIPBOARD_METHOD=wlc
# Set-up history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt EXTENDED_HISTORY    
setopt SHARE_HISTORY       
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS  
setopt HIST_IGNORE_SPACE 
setopt HIST_REDUCE_BLANKS       
setopt AUTO_CD                 
setopt AUTO_PUSHD             
setopt PUSHD_IGNORE_DUPS     

# 1. Load the widgets
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -M vicmd 'k' history-beginning-search-backward-end
bindkey -M vicmd 'j' history-beginning-search-forward-end

bindkey -M viins "^[[A" history-beginning-search-backward-end
bindkey -M viins "^[[B" history-beginning-search-forward-end

bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Set-up icons for files/folders in terminal using eza
# alias ls='eza -a --icons'
# alias ll='eza -al --icons'
# alias lt='eza -a --tree --level=2 --icons'
alias t='sh ~/scripts/fzf_open.sh'
# Use subtle colors for special dirs (foreground colors only)
LS_COLORS="${LS_COLORS//ow=34;42/ow=01;36}"  # bold cyan
LS_COLORS="${LS_COLORS//tw=30;42/tw=01;36}" # bold cyan
LS_COLORS="${LS_COLORS//st=37;44/st=01;33}" # bold yellow
export LS_COLORS

eval "$(zoxide init zsh)"
alias cd='z'

f ()
{
  "/home/kausthubh/scripts/fzf_open.sh"
}

# Yazi setup
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# PNPM setup
export PNPM_HOME="/home/kausthubh/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
eval ''

# NVM setup
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Go setup
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH

# Add local bin to PATH
export PATH=$HOME/.local/bin:$PATH

# bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
# Cuda path
# export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# opencode
export PATH=/home/kausthubh/.opencode/bin:$PATH
