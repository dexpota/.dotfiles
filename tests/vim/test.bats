#!/usr/bin/env bats

load helper.bash

setup() {
	setup_vim
}

@test "Vim opens representative filetypes with stable mappings and no automatic edits" {
	run_vim_checks core.vim
}

@test "Vim tolerates errors explicitly suppressed by filetype scripts" {
	cp "$BATS_TEST_DIRNAME/fixtures/suppressed-error.vim" "$VIM_TEST_RUNTIME/after/ftplugin/sh.vim"
	run_vim_checks core.vim
}

@test "Vim rejects unsuppressed filetype errors" {
	cp "$BATS_TEST_DIRNAME/fixtures/unsuppressed-error.vim" "$VIM_TEST_RUNTIME/after/ftplugin/sh.vim"
	if run_vim_checks core.vim; then
		echo "Expected the filetype error to fail validation" >&2
		return 1
	fi
	run grep -F 'E184' "$vim_test_directory/errors"
	[ "$status" -eq 0 ]
	[[ "$output" == *"ShFoldIfDoFor"* ]]
}

@test "Vim preserves whitespace on save and persists undo across sessions" {
	run_vim_checks save.vim
	run_vim_checks undo.vim
}

@test "native packages load without activating preserved legacy plugins" {
	for package in colorschemes goyo tabular vim-pencil vim-surround; do
		if [ ! -f "$repository_root/vim/.vim/pack/plugins/start/$package/.git" ]; then
			skip "Initialize retained Vim submodules to run package integration checks"
		fi
	done
	ln -s "$repository_root/vim/.vim/pack" "$VIM_TEST_RUNTIME/pack"
	ln -s "$repository_root/vim/.vim/bundle" "$VIM_TEST_RUNTIME/bundle"
	run_vim_checks packages.vim
}

@test "Vim installation initializes native packages without legacy compilation or pulls" {
	run make -n -C "$repository_root" vim
	[ "$status" -eq 0 ]
	[[ "$output" == *"submodule update --init --recursive -- vim/.vim/pack/plugins/start"* ]]
	[[ "$output" == *"stow --restow"* ]]
	[[ "$output" != *"YouCompleteMe"* ]]
	[[ "$output" != *"pathogen"* ]]
	[[ "$output" != *"git pull"* ]]
}
