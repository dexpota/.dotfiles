#!/usr/bin/env bash

response=$(curl -w '\n%{http_code}' -s -o - https://api.github.com/repos/$1/releases/latest)

response_body=$(echo "$response" | head -n -1)
response_code=$(echo "$response" | tail -1)

if [[ $response_code == 200 ]]; then
	echo "$response_body" | jq -r ".assets[].browser_download_url" | parallel -j+1 wget
fi

#echo "$response_body"
#echo "$response_code"

#curl --silent "https://api.github.com/repos/$1/releases/latest" | 
#		jq -r ".assets[] | select(.name | test(\"$2\")) | .browser_download_url"
