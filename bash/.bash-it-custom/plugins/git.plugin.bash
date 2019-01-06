# Infect a git repository with a vim plugin, this command is supposed to work
# with a .dotfiles repository
#
# $1 - The git repository's URL.
# $2 - The local directory where to clone the repository as a submodule.
#
# Examples
#
#	git-infect-pathogen https://github.com/vim-airline/vim-airline vim-airline
#
function git_infect_pathogen() {
	local target="$(git rev-parse --show-toplevel)/.vim/bundle/"
	[ -f "$target" ] && git submodule add $1 "${target}${2}"
}

function git_find_all() {
	find . -name .git -type d -prune | while read directory ; do
		git -C $directory remote -v
	done
}
