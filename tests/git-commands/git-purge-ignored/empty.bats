#!/usr/bin/env bats

empty_directory=$(mktemp -d)

setup() {
	cd "$empty_directory"
}

teardown() {
	rmdir "$empty_directory"
}

@test "invoking outside a git repository fails" {	
	run git-purge-ignored 
	[ "$status" -eq 1 ]
}
