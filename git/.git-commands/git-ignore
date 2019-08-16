#!/usr/bin/env bash
#
# @author Fabrizio Destro (dexpota@github)
# @copyright 2019
# @license GNU GPLv3
#

usage() {
    echo """
  git ignore uses gitignore.io service to generate a gitignore configuration
  file.

  Examples:

    # search
    git ignore search jupyter

    # list supported languages
    git ignore list

    # interactively choose a language
    git ignore -i

    # generate a gitignore configuration file for python
    git ignore python > .gitignore
"""
}

set -o nounset
set -o errexit

gitignore=https://www.gitignore.io/api

while getopts "hi" opt; do
  case ${opt} in
    h)
        usage
        exit 0
        ;;
    i)
        curl -Ls "$gitignore/list?format=lines" | pick | xargs -I{} git ignore {}
        exit 0
        ;;
    \? )
        echo "Invalid option: -$OPTARG" 1>&2
        exit 1
        ;;
  esac
done
shift $((OPTIND -1))

subcommand=${1:-}
case "$subcommand" in
    "")
        usage
        exit 0
        ;;
    list)
        curl -Ls "$gitignore/list?format=lines"
        exit 0
        ;;
    search)
        shift
        query=${1:-}

        curl -Ls "$gitignore/list?format=lines" | grep "$query"
        exit 0
        ;;
    *)
        curl -Ls "$gitignore/$*"
        exit 0
        ;;
esac
shift $((OPTIND - 1))
