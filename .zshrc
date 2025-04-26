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
ENABLE_CORRECTION="true"

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
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# neovim
# move this to /usr/local/bin
export PATH="$PATH:/usr/bin/nvim-linux64/bin"
export EDITOR='nvim'

# direnv
if [[ "$OSTYPE" =~ ^linux ]]; then
    eval "$(direnv hook zsh)"
fi

# python
# switch with uv
source "$HOME/.rye/env"
eval "$(~/.rye/shims/rye self completion -s zsh)"

# ruby
# remove after website
if [[ "$OSTYPE" =~ ^linux ]]; then
	eval "$(~/.rbenv/bin/rbenv init - zsh)"
fi

# rust
. "$HOME/.cargo/env"

# sdk ie jvm
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export SDKMAN_DIR="$HOME/.sdkman"

# node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin


# brew (for mac)
if [[ "$OSTYPE" =~ ^darwin ]]; then
	export PATH="/opt/homebrew/bin:$PATH"
fi
