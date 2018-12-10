#!/usr/bin/env bats

repository_directory=$(mktemp -d)

load helper

setup() {
	cd "$repository_directory"

	create_git_repository
	git add -f .
	touch "ignore"
	git commit -m "Test commit."
}

teardown() {
	rm -rf "$repository_directory"	
}

@test "testing multiple runs have no effects" {
	run git-purge-ignored
	[ "$status" -eq 0 ]
	run git-purge-ignored
	[ "$status" -eq 0 ]
}
# TODO test with no files being deleted
#
@test "testing which files are being deleted when called inside a subdirectory" {	
	cd "subdirectory"
	run git-purge-ignored
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = ".ignore" ]
	[ "${lines[1]}" = "ignore" ]
}

# TODO test that only tracked files inside the .gitignore rules are removed
@test "testing which files are being deleted" {	
	run git-purge-ignored
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = ".hidden/goo" ]
	[ "${lines[1]}" = ".ignore" ]
	[ "${lines[2]}" = "subdirectory/.ignore" ]
	[ "${lines[3]}" = "subdirectory/ignore" ]
}
