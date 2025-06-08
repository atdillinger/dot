#!/bin/zsh

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# Load .bashrc and other files...
for file in ~/.{functions,exports,aliases}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file

autoload -Uz compinit && compinit

HISTTIMEFORMAT="%F %T "
unsetopt correct

export LANG=en_US.UTF-8
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=true
export MANPATH="/usr/local/man:$MANPATH"

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt ALWAYS_TO_END
setopt EXTENDED_HISTORY
setopt AUTO_CD
setopt PROMPT_SUBST
setopt HIST_IGNORE_DUPS
setopt DVORAK


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
fpath+=~/.zfunc
source $ZSH/oh-my-zsh.sh
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Add binaries to PATH
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH

# brew (for mac)
if [[ "$OSTYPE" =~ ^darwin ]]; then
	export PATH="/opt/homebrew/bin:$PATH"
fi

# direnv
eval "$(direnv hook zsh)"


# go
if [ -f $HOME/.local/go/bin/go ]; then
	export GOPATH=$HOME/go
	export PATH=$PATH:$HOME/.local/go/bin:$GOPATH/bin
fi

# kubectl
if which kubectl > /dev/null; then
	source <(kubectl completion zsh)
fi

# neovim
export PATH="$PATH:/usr/bin/nvim-linux64/bin"
export EDITOR='nvim'

# node
if [ -d $HOME/.nvm/ ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi

# python
if [ -d $HOME/.uv/ ]; then
	eval "$(uv generate-shell-completion zsh)"
	eval "$(uvx --generate-shell-completion zsh)"
fi

# ruby
if [[ "$OSTYPE" =~ ^linux ]]; then
	eval "$(~/.rbenv/bin/rbenv init - zsh)"
fi

# rust
if [ -d $HOME/.cargo/ ]; then
	source "$HOME/.cargo/env"
fi

# sdk ie jvm
if [ -d $HOME/.sdkman/ ]; then
	[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
	export SDKMAN_DIR="$HOME/.sdkman"
fi
