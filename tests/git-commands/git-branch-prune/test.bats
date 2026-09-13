#!/usr/bin/env bats

setup() {
	test_directory=$(mktemp -d)
	origin="$test_directory/origin.git"
	seed="$test_directory/seed"
	working_copy="$test_directory/working-copy"
	command="$BATS_TEST_DIRNAME/../../../git/git-commands/git-branch-prune.sh"

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
}

teardown() {
	rm -rf "$test_directory"
}

create_stale_branch() {
	branch=$1
	merged=$2

	git -C "$seed" switch --quiet -c "$branch" main
	echo "$branch" > "$seed/$branch.txt"
	git -C "$seed" add "$branch.txt"
	git -C "$seed" commit --quiet -m "Add $branch"
	git -C "$seed" push --quiet --set-upstream origin "$branch"

	git -C "$working_copy" fetch --quiet origin
	git -C "$working_copy" branch --track "$branch" "origin/$branch"

	if [ "$merged" = true ]; then
		git -C "$seed" switch --quiet main
		git -C "$seed" merge --quiet --ff-only "$branch"
		git -C "$seed" push --quiet origin main
		git -C "$working_copy" pull --quiet --ff-only origin main
	fi

	git -C "$seed" push --quiet origin --delete "$branch"
	git -C "$working_copy" fetch --quiet --prune origin
}

@test "succeeds when there are no stale branches" {
	cd "$working_copy"

	run "$command"

	[ "$status" -eq 0 ]
	[ -z "$output" ]
}

@test "deletes a merged branch with a gone upstream" {
	create_stale_branch merged-branch true
	cd "$working_copy"

	run "$command"

	[ "$status" -eq 0 ]
	! git show-ref --verify --quiet refs/heads/merged-branch
}

@test "preserves an unmerged branch by default" {
	create_stale_branch unmerged-branch false
	cd "$working_copy"

	run "$command"

	[ "$status" -ne 0 ]
	git show-ref --verify --quiet refs/heads/unmerged-branch
}

@test "force deletes an unmerged branch" {
	create_stale_branch unmerged-branch false
	cd "$working_copy"

	run "$command" --force

	[ "$status" -eq 0 ]
	! git show-ref --verify --quiet refs/heads/unmerged-branch
}

@test "deletes multiple stale branches" {
	create_stale_branch first-branch true
	create_stale_branch second-branch true
	cd "$working_copy"

	run "$command"

	[ "$status" -eq 0 ]
	! git show-ref --verify --quiet refs/heads/first-branch
	! git show-ref --verify --quiet refs/heads/second-branch
}

@test "dry run lists a stale branch without deleting it" {
	create_stale_branch stale-branch false
	cd "$working_copy"

	run "$command" --dry-run

	[ "$status" -eq 0 ]
	[ "$output" = "stale-branch" ]
	git show-ref --verify --quiet refs/heads/stale-branch
}

@test "rejects unknown options" {
	cd "$working_copy"

	run "$command" --unknown

	[ "$status" -eq 2 ]
	[[ "$output" == *"Unknown option: --unknown"* ]]
}

@test "fails outside a Git repository" {
	cd "$test_directory"

	run "$command"

	[ "$status" -eq 1 ]
	[[ "$output" == *"Current directory is not a Git repository."* ]]
}
