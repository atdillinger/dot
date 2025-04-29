# Machine Setup - YMMV

## Linux

> For steps that refer to an OS other than linux,
> It assumed that the machine is a mac.
> See mac instructions below.

1. `sudo apt install zsh && chsh -s $(which zsh)`
1. `sudo apt update`
1. `sudo apt upgrade`
1. `make ubuntu`
1. `make popos`
1. `make dotfiles`
1. for linux machines run `make nvim`
1. `make git-config`
1. for _linux_ machines run `make gcm`
1. `git config --global user.name dillinger;`
1. for _linux_ machines run `make tmuxinator`
1. `make all`

## Mac Setup

> Mac setup is not supplied by `make`.
> However the following notes could be helpful

1. use [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH#how-to-install-zsh-on-many-platforms)
1. install [homebrew](https://brew.sh/)
1. then the following:

```sh
brew install --cask ghostty
brew install direnv \
    jq \
    yq \
    direnv \
    tmux \
    tmuxinator;
brew install neovim;
git clone https://github.com/atdillinger/kickstart.nvim.git $(HOME)/.config/nvim;
rm -rf ~/.config/nvim/.git;
rm -rf ~/.config/nvim/.git;
brew install jesseduffield/lazygit/lazygit;
brew install ripgrep;
git config --global core.editor nvim;
cargo install fd-find;
brew install rbenv ruby-build
rbenv install 3.3.1
rbenv global 3.3.1

make tmuxinator # still to figure out
```

> Based on : <https://github.com/jessfraz/dotfiles>
