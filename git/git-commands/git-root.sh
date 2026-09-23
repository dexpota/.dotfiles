#!/usr/bin/env sh

root=$(git rev-parse --show-toplevel)

if [ -z "$root" ]; then
	cd "$root" || exit 1
fi
