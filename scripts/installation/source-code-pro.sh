#!/usr/bin/env bash

{
	cd $(mktemp -d)
	gh-last-release-assets adobe-fonts/source-code-pro ~/.fonts
}
