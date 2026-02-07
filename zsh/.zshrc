export EDITOR="nvim"

eval "$(starship init zsh)"

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh

bindkey '^ ' autosuggest-accept
export ZSH_SYSTEM_CLIPBOARD_METHOD=wlc
# Set-up history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set-up icons for files/folders in terminal using eza
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=2 --icons'
alias t='sh ~/scripts/fzf_open.sh'

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
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Go setup
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH

# Add local bin to PATH
export PATH=$HOME/.local/bin:$PATH

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# Cuda path
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# opencode
export PATH=/home/kausthubh/.opencode/bin:$PATH
