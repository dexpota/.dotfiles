#!/usr/bin/env sh

{
	cd $(mktemp -d)
	gh-last-release-assets adobe-fonts/source-code-pro ~/.fonts
}
