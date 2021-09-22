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
