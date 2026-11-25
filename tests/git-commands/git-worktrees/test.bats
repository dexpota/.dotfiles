#!/usr/bin/env bats

setup() {
	test_directory=$(mktemp -d)
	origin="$test_directory/origin.git"
	seed="$test_directory/seed"
	working_copy="$test_directory/working-copy"
	command="$BATS_TEST_DIRNAME/../../../git/git-commands/git-worktrees"

	git init --bare --quiet "$origin"
	git init --quiet "$seed"
	git -C "$seed" config user.name "Test User"
	git -C "$seed" config user.email "test@example.com"
	printf 'initial\n' > "$seed/file.txt"
	git -C "$seed" add file.txt
	git -C "$seed" commit --quiet -m "Initial commit"
	git -C "$seed" branch -M main
	git -C "$seed" remote add origin "$origin"
	git -C "$seed" push --quiet --set-upstream origin main
	git --git-dir="$origin" symbolic-ref HEAD refs/heads/main
	git clone --quiet "$origin" "$working_copy"
}

teardown() {
	rm -rf "$test_directory"
}

@test "summarizes worktree changes and commits ahead of upstream" {
	git -C "$working_copy" config user.name "Test User"
	git -C "$working_copy" config user.email "test@example.com"
	printf 'committed\n' > "$working_copy/committed.txt"
	git -C "$working_copy" add committed.txt
	git -C "$working_copy" commit --quiet -m "Local commit"
	printf 'modified\n' >> "$working_copy/file.txt"
	printf 'untracked\n' > "$working_copy/new.txt"

	cd "$working_copy"
	run "$command"

	[ "$status" -eq 0 ]
	[[ "$output" == *"Branch: main"* ]]
	[[ "$output" == *"Changes: 1 unstaged, 1 untracked"* ]]
	[[ "$output" == *"Push: 1 to push"* ]]
}
