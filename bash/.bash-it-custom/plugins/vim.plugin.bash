# Infect vim with a pathogen
function infect() {
	[ -d "~/.vim/bundle" ] && git clone $1 ~/.vim/bundle
}
