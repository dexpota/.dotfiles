#!/usr/bin/env bats

repository_directory=$(mktemp -d)

load helper

setup() {
	cd "$repository_directory"

	create_git_repository_2
	git commit -m "Test commit."
}

teardown() {
	rm -rf "$repository_directory"	
}

@test "testing when no files will be deleted" {
	run git-purge-ignored
	[ "$status" -eq 0 ]
}
