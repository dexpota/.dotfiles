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
