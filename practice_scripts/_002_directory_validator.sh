#!/usr/bin/env bash

# Directory validator
# Input: path
# Verify it exists, is a directory, and is readable
# Print absolute path
# Exit codes must distinguish: missing vs not-a-dir vs permission denied

set -euo pipefail

# verifying arg number is 1
if [ $# -ne 1 ]; then
	printf 'Usage: %s <directory-path> \n' "$0" >&2
	exit 1
fi

DIR="$1"

# valid path check
if [ ! -e "$DIR" ]; then
	printf "Error: path does not exist: %s \n" "$DIR" >&2
	exit 2
fi

# directory check
if [ ! -d "$DIR" ]; then
	printf "Error : Not a valid directory: %s \n" "$DIR" >&2
	exit 3
fi

# readable check
if [ ! -r "$DIR" ]; then
	printf "Error : Directory not readable: %s \n" "$DIR" >&2
	exit 4
fi	

# realpath is installed or not
if ! command -v realpath >dev/null 2>&1; then
	printf "Error: 'realpath' command not available \n" >&2
  	exit 5
fi

realpath "$DIR"

# find all files in that path
#find "$DIR" -maxdepth 1 -type f -print

#if [ ! -e "$DIR" ] || [ ! -d "$DIR" ] || [ ! -r "$DIR" ] ; then
	#	exit 2
#fi

