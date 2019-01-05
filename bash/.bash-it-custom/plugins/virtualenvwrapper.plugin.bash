#!/usr/bin/env bash

# set the workon home for virtualenvs if not already set
export WORKON_HOME=${WORKON_HOME-$HOME/.virtualenvs}

# get the location of venvwrapper initialization script
VIRTUALENVWRAPPER_SCRIPT="/usr/local/bin/virtualenvwrapper.sh"

# if the file does exists
if [[ -f "$VIRTUALENVWRAPPER_SCRIPT" ]]; then

	if [[ -z "$VIRTUALENVWRAPPER_PYTHON" ]]; then
		# find which python version has virtualenvwrapper installed
		if python2 -c "import virtualenvwrapper" 1>/dev/null 2>&1; then
			VIRTUALENVWRAPPER_PYTHON=$(which python2)
		elif python3 -c "import virtualenvwrapper" 1>/dev/null 2>&1; then
			VIRTUALENVWRAPPER_PYTHON=$(which python3)
		fi
	fi

	source "$VIRTUALENVWRAPPER_SCRIPT"
fi
