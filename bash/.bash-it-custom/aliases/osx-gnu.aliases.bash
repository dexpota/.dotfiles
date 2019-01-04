#!/usr/bin/env bash

[ "$OSTYPE" -ne "darwin*" ] && return

command -v ghead 1>/dev/null 2>&1 && alias head=ghead
command -v gmktemp 1>/dev/null 2>&1 && alias mktemp=gmktemp
