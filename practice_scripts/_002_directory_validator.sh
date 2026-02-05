#!/usr/bin/env bash

set -euo pipefail

# verifying arg number is 1
if [ $# -ne 1 ]; then
	printf 'Usage: %s <directory-path> \n' "$0" >&2
	exit 1
fi

DIR="$1"

# valid path check
if [ ! -e "$DIR" ]; then
	printf '%s : Not a valid path \n' "$DIR" >&2
	exit 2
fi

# directory check
if [ ! -d "$DIR" ]; then
	printf '%s : Not a valid directory \n' "$DIR" >&2
	exit 3
fi

# readable check
if [ ! -r "$DIR" ]; then
	printf '%s : Not readable \n' "$DIR" >&2
	exit 4
fi	

realpath "$DIR"

# find all files in that path
#find "$DIR" -maxdepth 1 -type f -print

#if [ ! -e "$DIR" ] || [ ! -d "$DIR" ] || [ ! -r "$DIR" ] ; then
	#	exit 2
#fi

