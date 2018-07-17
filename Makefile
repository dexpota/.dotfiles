GIT_AUTHORNAME ?= $(shell bash -c 'read -p "- What is your github author name? " name; echo $$name')
GIT_AUTHOREMAIL ?= $(shell bash -c 'read -p "- What is your github author email? " email; echo $$email')

all:
	@echo "Please specify one target."

git-submodule:
	git submodule init
	git pull --recurse-submodules

ycm:
	@echo "Compiling ycm"
	cd ${HOME}/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.py --clang-completer --rust-completer
# todo this is not sufficient in archlinux, libtinfo.so.5 is missing and can be found inside ncurses5-compat-libs AUR package

vim: ycm git-submodule
	stow vim

bash:
	stow bash

git:
	sed -e "s/AUTHORNAME/${GIT_AUTHORNAME}/g" -e "s/AUTHOREMAIL/${GIT_AUTHOREMAIL}/g" git/.gitconfig.example > git/.gitconfig
	stow git
