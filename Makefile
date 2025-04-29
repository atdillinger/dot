SHELL := /bin/zsh
.DEFAULT_GOAL := help

nvim:  ## nvim-linux64
	# move to .local/bin
	sudo apt install gcc;
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz;
	sudo rm -rf /usr/bin/nvim;
	sudo tar -C /usr/bin -xzf nvim-linux64.tar.gz;
	rm -rf $(CURDIR)/nvim-linux64.tar.gz;
	git clone https://github.com/atdillinger/kickstart.nvim.git $(HOME)/.config/nvim;
	sudo install lazygit /usr/local/bin;
	( \
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_0.42.0_Linux_x86_64.tar.gz"; \
		tar xf lazygit.tar.gz lazygit; \
	)
	rm $(CURDIR)/lazygit;
	rm $(CURDIR)/lazygit.tar.gz;
	sudo apt-get install ripgrep;
	git config --global core.editor nvim;
	$(MAKE) rust;
	cargo install fd-find;
	$(MAKE) python;
	rye install ruff-lsp;

OMZ=$(HOME)/.oh-my-zsh/oh-my-zsh.sh
OMZ:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";

.PHONY: wrapper recipe for oh my zsh
ohmyzsh: ## omz
	$(MAKE) $(OMZ)

.PHONY: link dotfiles to home dir
dotfiles: ## dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".git" ); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;

.PHONY: configure git
git-config: ## configure git
	git config --global remote.origin.prune true;
	git config --global log.abbrevCommit true;
	git config --global core.abbrev 8;
	git config --global alias.lease 'push --force-with-lease';
	git config --global init.defaultBranch main;
	git config --global push.autoSetupRemote true;
	git config --global advice.skippedCherryPicks false;
	git config --global help.autocorrect immediate;
	git config --global rerere.enabled true;
	mkdir -p $(HOME)/.config/git;
	ln -sfn $(CURDIR)/gitignore $(HOME)/.config/git/ignore;

GCM=/usr/local/bin/git-credential-manager
$(GCM): ## install and configure git credential manager
	# move to .local/bin
	curl -Lo /tmp/gcm.tar.gz "https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.tar.gz";
	tar xf /tmp/gcm.tar.gz /tmp/git-credential-manager;
	sudo install /tmp/git-credential-manager /usr/local/bin;
	/usr/local/bin/git-credential-manager configure;
	sudo apt-get install pass;
	gpg --full-generate-key;
	pass init `gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}' | sed  's/rsa3072\///g'`;
	git config --global credential.credentialStore gpg;

.PHONY: wrappre recipe for git-credential-manager
gcm:
	$(MAKE) $(GCM)

docker: ## install and configure docker
	for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do \
		sudo apt-get remove $$pkg; \
	done;
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# # Add the repository to Apt sources:
	# echo \
	# 	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	# 	$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	# 	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	# sudo apt-get update
	# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo groupadd docker
	sudo usermod -aG docker $USER
	newgrp docker

RBENV=$(HOME)/.rbenv/bin/rbenv
$(RBENV): ## install ruby
	sudo apt update
	sudo apt install \
		libyaml-dev \
		libz-dev \
		libssl-dev \
		build-essential;
	( \
		git clone https://github.com/rbenv/rbenv.git $(HOME)/.rbenv; \
		git clone https://github.com/rbenv/ruby-build.git $(HOME)/.rbenv/plugins/ruby-build; \
		$(HOME)/.rbenv/bin/rbenv init; \
		$(HOME)/.rbenv/bin/rbenv install 3.3.1; \
		$(HOME)/.rbenv/bin/rbenv global 3.3.1; \
	)

TMUXINATOR=$(HOME)/.rbenv/shims/tmuxinator
tmuxinator: ## install tmuxinator
	$(MAKE) $(RBENV)
	gem install tmuxinator
	mkdir -p $(HOME)/.zfunc/
	wget https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh -O ~/.zfunc/_tmuxinator

HUGO=$(HOME)/.local/bin/hugo
$(HUGO): ## install hugo for blog development
	rm -rf $(HOME)/.local/bin/hugo
	curl -LO https://github.com/gohugoio/hugo/releases/download/v0.146.5/hugo_0.146.5_linux-amd64.tar.gz
	tar -C $(HOME)/.local/bin -xzf hugo_0.146.5_linux-amd64.tar.gz
	rm -rf $(CURDIR)/hugo_0.146.5_linux-amd64.tar.gz

GO=$(HOME)/.local/go/bin/go
$(GO): ## install go
	rm -rf $(HOME)/.local/go/
	curl -Lo $(CURDIR)/go.tar.gz "https://golang.org/dl/go1.22.5.linux-amd64.tar.gz"
	tar xf $(CURDIR)/go.tar.gz go
	mv $(CURDIR)/go $(HOME)/.local
	rm $(CURDIR)/go.tar.gz

NVM=$(HOME)/.nvm/nvm.sh
$(NVM): ## install node
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

UV=$(HOME)/.local/bin/uv
UVX=$(HOME)/.local/bin/uvx
$(UV) $(UVX): ## install rye for python development
	curl -LsSf https://astral.sh/uv/install.sh | sh

RUSTUP=$(HOME)/.cargo/bin/rustup
RUSTC=$(HOME)/.cargo/bin/rustc
$(RUSTUP) $(RUSTC): ## install rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	mkdir -p $(HOME)/.zfunc/;
	rustup completions zsh cargo > ~/.zfunc/_cargo;

SDKMAN=$(HOME)/.sdkman/bin/sdkman-init.sh
$(SDKMAN):  ## install sdkman to manage jvm
	curl -s "https://get.sdkman.io" | bash
	( \
		source $(HOME)/.sdkman/bin/sdkman-init.sh; \
		sdk install java 21.0.2-zulu; \
		sdk use java 21.0.2; \
	)

SQLITE=$(HOME)/.local/bin/sqlite3
SQLITEANALYZER=$(HOME)/.local/bin/sqlite3_analyzer
SQLDIFF=$(HOME)/.local/bin/sqldiff
$(SQLITE) $(SQLITE_ANALYZER) $(SQLDIFF): ## install sqlite
	curl "https://www.sqlite.org/2024/sqlite-tools-linux-x64-3460000.zip" -o $(CURDIR)/sqlite.zip
	unzip $(CURDIR)/sqlite.zip -d $(HOME)/.local/bin/
	rm sqlite.zip

.PHONY: clean-sqlite
clean-sqlite:
	rm $(SQLITE);
	rm $(SQLITEANALYZER);
	rm $(SQLDIFF);

.PHONY: all
all: ## do it all
	$(MAKE) $(HUGO)
	$(MAKE) $(GO)
	$(MAKE) $(SDKMAN)
	$(MAKE) $(SQLITE) $(SQLITE_ANALYZER) $(SQLDIFF)
	$(MAKE) $(UV) $(UVX)
	$(MAKE) $(RUSTUP)
	$(MAKE) $(NVM)
	$(MAKE) $(RBENV)

popos: ## popos setup
	sudo apt install \
		build-essential \
		apt-transport-https \
		ca-certificates \
		curl \
		software-properties-common \
		apache2-utils \
		make \
		chromium-browser \
		firefox \
		gnome-tweaks \
		gnome-shell-extensions \
		dconf-editor;
	sudo apt autoremove -y;
	sudo apt autoclean -y;
	sudo reboot now;
	sudo apt install gnome-tweaks;

ubuntu: ## base ubuntu installs
	sudo apt install \
		dos2unix \
		shellcheck \
		tmux \
		shellcheck \
		zip \
		unzip \
		direnv \
		xclip \
		xsel;

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
