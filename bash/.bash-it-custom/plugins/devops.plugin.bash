
# Examples
# 	get_latest_release adobe-fonts/source-code-pro
#	wget -i <(get_latest_release adobe-fonts/source-code-pro  ".+otf")
#
function get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		jq -r ".assets[] | select(.name | test(\"$2\")) | .browser_download_url"
}

export -f get_latest_release

function gi() {
	curl -L -s https://www.gitignore.io/api/$@
}

export -f gi
