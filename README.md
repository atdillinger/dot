# Machine Setup


## Getting Started

## Prereqs

1. `zsh` - `sudo apt install zsh` and `chsh -s $(which zsh)`

1. `sudo apt update`
1. `sudo apt upgrade`
1. `make ubuntu`
1. `make dotfiles`
1. `make nvim-linux64`
1. `make go`
1. `make rust`
1. `make sqlite`
1. `make python`
1. `make node`
1. `make sdkman`
`make hugo`
1. `make git`
1. `make git-config`

1. if `popos` then `make popos`

1. if `"$OSTYPE" =~ ^darwin` 
`make mac`
`make nvim-mac`

1. if `"$OSTYPE" =~ ^linux` 
    1. make gcm

Check the recipes available via `make` or `make help`

### Docker

- Docker for Desktop

### Keyboard Improvements

- [Map Caps Lock to Right Control Key](https://superuser.com/questions/949385/map-capslock-to-control-in-windows-10)

## Mac

use zsh
install homebrew
install iterm2

```
# Node/NPM
# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

# mac
# export HOMEBREW_PREFIX="/opt/homebrew"
# export HOMEBREW_CELLAR="/opt/homebrew/cellar"
# export HOMEBREW_REPOSITORY="/opt/homebrew"
# export PATH="/opt/homebrew/bin:opt/homebrew/sbin${PATH+:$PATH}"
# export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
# export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
```

> Based on : <https://github.com/jessfraz/dotfiles>
