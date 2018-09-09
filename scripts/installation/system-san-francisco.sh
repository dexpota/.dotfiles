#!/usr/bin/env bash

{
	cd ~/.fonts 
	gh-curl-repo AppleDesignResources/SanFranciscoFont ".*\.otf" . 
}
