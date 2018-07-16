all:
	@echo "Please specify one target."

git-submodule:
	git submodule init
	git pull --recurse-submodules

ycm:
	@echo "Compiling ycm"
	cd ${HOME}/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.py --clang-completer --rust-completer	

vim: ycm git-submodule
	stow vim
