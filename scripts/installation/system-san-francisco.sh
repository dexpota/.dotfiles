#!/usr/bin/env bash

if [ ! -d ~/.fonts ]; then
	mkdir ~/.fonts
fi

cd ~/.fonts
gh-curl-repo AppleDesignResources/SanFranciscoFont ".*\.otf" .
