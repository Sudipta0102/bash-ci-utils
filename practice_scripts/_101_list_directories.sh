#!/usr/bin/env bash

set -euo pipefail

# **************************************************
# List only directories
# Input: directory
# Print only immediate subdirectories (no recursion)
# **************************************************

# chack 1 arg
if [ $# -ne 1 ]; then
	printf "Usage: %s <directory-path> \n" "$0">&2
	exit 1
fi

DIR="$1"

# valid path check
if [ ! -e "$DIR" ]; then
	printf "Error: not a valid path: %s \n" "$DIR">&2	
	exit 2
fi

# directory or not
if [ ! -d "$DIR" ]; then
	printf "Error: not a directory: %s \n" "$DIR">&2
	exit 3
fi

# readability check
if [ ! -r "$DIR" ]; then
	printf "Error: directory doesn't have read permission: %s \n" "$DIR">&2
	exit 4
fi

find "$DIR" -mindepth 1 -maxdepth 1 -type d ! -path "$DIR" -print
# I am not able to exclude the input path and only print folders here. 