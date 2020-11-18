command -v ghead 1>/dev/null 2>&1 && alias head=ghead
command -v gmktemp 1>/dev/null 2>&1 && alias mktemp=gmktemp
alias dns-refresh=dscacheutil -flushcache && sudo killall -HUP mDNSResponder

# Start VS Code from the terminal
alias code="open -a 'Visual Studio Code'"
