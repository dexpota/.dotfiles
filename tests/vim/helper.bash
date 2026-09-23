setup_vim() {
	repository_root="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
	vim_test_directory="$(mktemp -d)"
	export VIM_TEST_DIRECTORY="$vim_test_directory"
	export VIM_TEST_RUNTIME="$vim_test_directory/.vim"
	mkdir -p "$VIM_TEST_RUNTIME/after" "$VIM_TEST_RUNTIME/backup" \
		"$VIM_TEST_RUNTIME/swp" "$VIM_TEST_RUNTIME/undo"
	cp "$repository_root/vim/.vimrc" "$vim_test_directory/.vimrc"
	cp "$repository_root/vim/.vim/mapping.vim" "$VIM_TEST_RUNTIME/mapping.vim"
	cp -R "$repository_root/vim/.vim/after/ftplugin" "$VIM_TEST_RUNTIME/after/"
}

teardown() {
	if [ -n "${vim_test_directory:-}" ]; then
		rm -rf "$vim_test_directory"
	fi
}

run_vim_checks() {
	run vim -N -n -i NONE -es -u "$vim_test_directory/.vimrc" \
		--cmd 'let &runtimepath = $VIM_TEST_RUNTIME . "," . $VIMRUNTIME . "," . $VIM_TEST_RUNTIME . "/after" | let &packpath = &runtimepath' \
		-S "$BATS_TEST_DIRNAME/$1"
	if [ "$status" -ne 0 ]; then
		printf '%s\n' "$output" >&2
		if [ -f "$vim_test_directory/errors" ]; then
			sed -n '1,160p' "$vim_test_directory/errors" >&2
		fi
		return 1
	fi
	[ -f "$vim_test_directory/passed" ]
}
