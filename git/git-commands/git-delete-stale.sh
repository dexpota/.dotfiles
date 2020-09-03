#!/usr/bin/env bash

LANG=en git branch --format='%(if:equals=gone)%(upstream:track,nobracket)%(then)%(refname:short)%(end)' | grep '.' | grep -v "\*"  | xargs git branch -d
