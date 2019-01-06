function taskscommit() {
	if [ ! -d "$HOME/.task" ]; then
		echo "~/.task is missing"
		return
	fi

	git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task/" commit -am "Updating tasks."
	local retval=$?
	if [ "$retval" -ne 0 ]; then
		echo "git commit failed"
		return
	fi

	git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task/" push
	local retval=$?
	if [ "$retval" -ne 0 ]; then
		echo "git push failed"
		return
	fi
}
export -f taskscommit

function taskspull() {
	if [ ! -d "$HOME/.task" ]; then
		echo "~/.task is missing"
		return
	fi

	git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task/" pull
	local retval=$?
	if [ "$retval" -ne 0 ]; then
		echo "git pull failed"
		return
	fi
}
export -f taskspull

function taskstatus() {
	if [ ! -d "$HOME/.task" ]; then
		echo "~/.task is missing"
		return
	fi

	git --git-dir "$HOME/.task/.git" --work-tree="$HOME/.task/" status
}
export -f taskstatus
