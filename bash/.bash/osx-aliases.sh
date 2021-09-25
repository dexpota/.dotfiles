command -v ghead 1>/dev/null 2>&1 && alias head=ghead
command -v gmktemp 1>/dev/null 2>&1 && alias mktemp=gmktemp
command -v gsort 1>/dev/null 2>&1 && alias sort=gsort

# Clean local DNS cache. Found on the Internet, I think it does not always work.
alias dns-refresh="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# Start VS Code from the terminal
alias code="open -a 'Visual Studio Code'"
