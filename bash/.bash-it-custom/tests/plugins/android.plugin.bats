#!/usr/bin/env bats

setup() {
	echo "setup"
}

teardown() {
	echo "teardown"
}

@test "testing android.plugin.bash" {
	load ../plugins/android.plugin	
}
