#!/usr/bin/env bats

setup() {
	test_directory=$(mktemp -d)
	origin="$test_directory/origin.git"
	seed="$test_directory/seed"
	working_copy="$test_directory/working-copy"
	command="$BATS_TEST_DIRNAME/../../../git/git-commands/git-branch-align.sh"

	git init --bare --quiet "$origin"
	git init --quiet "$seed"
	git -C "$seed" config user.name "Test User"
	git -C "$seed" config user.email "test@example.com"
	echo "initial" > "$seed/file.txt"
	git -C "$seed" add file.txt
	git -C "$seed" commit --quiet -m "Initial commit"
	git -C "$seed" branch -M main
	git -C "$seed" remote add origin "$origin"
	git -C "$seed" push --quiet --set-upstream origin main
	git --git-dir="$origin" symbolic-ref HEAD refs/heads/main
	git clone --quiet "$origin" "$working_copy"
	git -C "$working_copy" config user.name "Test User"
	git -C "$working_copy" config user.email "test@example.com"
}

teardown() {
	rm -rf "$test_directory"
}

push_remote_commit() {
	echo "remote" >> "$seed/file.txt"
	git -C "$seed" commit --quiet -am "Remote commit"
	git -C "$seed" push --quiet
}

@test "fast-forwards the current branch by default" {
	push_remote_commit
	cd "$working_copy"

	run "$command"

	[ "$status" -eq 0 ]
	[ "$(git -C "$working_copy" rev-parse HEAD)" = "$(git -C "$seed" rev-parse HEAD)" ]
}

@test "refuses to discard divergent local commits by default" {
	echo "local" >> "$working_copy/local.txt"
	git -C "$working_copy" add local.txt
	git -C "$working_copy" commit --quiet -m "Local commit"
	local_head=$(git -C "$working_copy" rev-parse HEAD)
	push_remote_commit
	cd "$working_copy"

	run "$command"

	[ "$status" -ne 0 ]
	[ "$(git -C "$working_copy" rev-parse HEAD)" = "$local_head" ]
}

@test "force-aligns a clean branch with its remote" {
	echo "local" >> "$working_copy/local.txt"
	git -C "$working_copy" add local.txt
	git -C "$working_copy" commit --quiet -m "Local commit"
	push_remote_commit
	cd "$working_copy"

	run "$command" --force

	[ "$status" -eq 0 ]
	[ "$(git -C "$working_copy" rev-parse HEAD)" = "$(git -C "$seed" rev-parse HEAD)" ]
}

@test "refuses forced alignment when tracked files are modified" {
	echo "uncommitted" >> "$working_copy/file.txt"
	working_head=$(git -C "$working_copy" rev-parse HEAD)
	push_remote_commit
	cd "$working_copy"

	run "$command" --force

	[ "$status" -ne 0 ]
	[ "$(git -C "$working_copy" rev-parse HEAD)" = "$working_head" ]
	grep -q "uncommitted" "$working_copy/file.txt"
}
