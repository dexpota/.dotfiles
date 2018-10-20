GIT_AUTHORNAME ?= $(shell bash -c 'read -p "- What is your github author name? " name; echo $$name')
GIT_AUTHOREMAIL ?= $(shell bash -c 'read -p "- What is your github author email? " email; echo $$email')
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
	cd ${MAKEFILE_DIR}/vim/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.py --clang-completer --rust-completer
# TODO this is not sufficient in archlinux, libtinfo.so.5 is missing and can be
# found inside ncurses5-compat-libs AUR package

.PHONY: vim
vim: ycm git-submodule ## Install vim configuration files
	stow vim

.PHONY: bash
# this rule doesn't produce any files but it depends on files inside bash
# directory
bash: $(shell find ./bash/ -type f) ## Install bash configuration files
	stow bash

.PHONY: newsboat
newsboat: ## Install newsboat configuration files.
	stow newsboat

.PHONY: git
git: ## Install git configuration files
	sed -e "s/AUTHORNAME/${GIT_AUTHORNAME}/g" -e "s/AUTHOREMAIL/${GIT_AUTHOREMAIL}/g" git/.gitconfig.local.example > git/.gitconfig.local
	stow git

.PHONY: fonts
fonts: ## Install system fonts into ~/.fonts
	+$(MAKE) -C fonts
