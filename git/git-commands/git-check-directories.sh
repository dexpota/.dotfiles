#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ $# -ne 1 ]; then
	echo "Illegal number of arguments, please specify a directory."
	exit -1
fi

if [[ -d "$1" ]]; then
  old_directory="`pwd`"
  cd "$1"
  for d in */; do
	cd "$d"
	if [ ! -d ".git" ]; then
		#echo "Directory $d is not a valid git repository."
		cd ..
		continue
	fi

	#printf "directory $d:"

  git diff --quiet --exit-code
  unstaged_changes=$?
  if [[ $unstaged_changes -eq 1 ]]; then
		printf "[${YELLOW}%s${NC}]" "Local unstaged changes"
  fi

  git diff --cached --quiet --exit-code
  staged_not_committed=$?
  if [[ $staged_not_committed -eq 1 ]]; then
		printf "[${YELLOW}%s${NC}]" "Local changes not committed"
  fi

	if [[ $staged_not_commited -ne 1 && $unstaged_changes -ne 1  ]]; then
		printf "[${GREEN}%s${NC}]" "Everything up-to-date"
	fi
	printf " %s\n" `pwd`
  cd ..
done
cd "$old_directory"
else
  echo "$1 is not a directory"
fi
