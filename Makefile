MAKEFILE_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: git-submodule
# Init submodule and pull all repositories.
git-submodule:
	git submodule init
	git pull --recurse-submodules

ycm:
	@echo "Compiling ycm"
	cd ${MAKEFILE_DIR}/vim/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && python3 ./install.py --clang-completer --rust-completer
# TODO this is not sufficient in archlinux, libtinfo.so.5 is missing and can be
# found inside ncurses5-compat-libs AUR package

.PHONY: vim
vim: ycm git-submodule ## Install vim configuration files
	mkdir -p ~/.vim/backup ~/.vim/swp ~/.vim/undo ~/.vim/autoload
	# Install pathogen
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	stow vim

BASH_CONFIG_FILES=$(shell find ./bash/ -type f -printf "%P\n")

.PHONY: bash
# this rule doesn't produce any files but it depends on files inside bash
# directory
bash: $(shell find ./bash/ -type f)  ## Install bash configuration files
	stow bash || echo "Remove all bash configuration files by running make bash-rm"

.PHONY: bash-rm
bash-rm:  ## Remove bash configuration files
	@(cd .. && rm -f $(BASH_CONFIG_FILES))
	@echo "All bash configuration files removed"

.PHONY: starship
starship:  ## Install the Starship prompt when missing
	@set -e; \
	if ! command -v starship >/dev/null 2>&1; then \
		case "$$(uname -s)" in \
			Darwin|Linux) ;; \
			*) echo "Starship installation is supported only on macOS and Linux." >&2; exit 1 ;; \
		esac; \
		install_dir="$$HOME/.local/bin"; \
		mkdir -p "$$install_dir"; \
		installer="$$(mktemp "$${TMPDIR:-/tmp}/starship-install.XXXXXX")"; \
		trap 'rm -f "$$installer"' 0; \
		trap 'exit 1' HUP INT TERM; \
		if command -v curl >/dev/null 2>&1; then \
			curl --fail --silent --show-error --location \
				https://starship.rs/install.sh --output "$$installer"; \
		elif command -v wget >/dev/null 2>&1; then \
			wget --quiet --output-document="$$installer" \
				https://starship.rs/install.sh; \
		else \
			echo "Installing Starship requires curl or wget." >&2; \
			exit 1; \
		fi; \
		sh "$$installer" --yes --bin-dir "$$install_dir"; \
	fi

.PHONY: zsh
zsh: starship $(shell find ./zsh/ -type f)  ## Install Zsh configuration files
	@stow zsh || { \
		echo "Remove conflicting Zsh configuration files and run make zsh again" >&2; \
		exit 1; \
	}

.PHONY: zsh-rm
zsh-rm:  ## Remove Zsh configuration links
	@stow --delete zsh

.PHONY: newsboat
newsboat: ## Install newsboat configuration files.
	stow newsboat

.PHONY: git
git: ## Install git configuration files
	@test -n "$(GITHUB_AUTHOR_NAME)" || (echo "GITHUB_AUTHOR_NAME is undefined." && exit 1)
	@test -n "$(GITHUB_AUTHOR_EMAIL)" || (echo "GITHUB_AUTHOR_EMAIL is undefined." && exit 1)
	sed -e "s/AUTHORNAME/$(GITHUB_AUTHOR_NAME)/g" -e "s/AUTHOREMAIL/${GITHUB_AUTHOR_EMAIL}/g" git/.gitconfig.local.example > git/.gitconfig.local
	stow git

# Requires jq and parallel installed
.PHONY: fonts
fonts: ## Install system fonts into ~/.fonts
	+$(MAKE) -C fonts

.PHONY: stardict
stardict: ## Install dictionaries for stardict
	wget -c http://download.huzheng.org/dict.org/stardict-dictd_www.dict.org_gcide-2.4.2.tar.bz2  -O - | tar -xz -C ~/.stardict/dic/
