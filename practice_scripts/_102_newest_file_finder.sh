#!/usr/bin/env bash

set -euo pipefail

# *****************************************
# Newest file finder
# Input: directory
# Print the most recently modified file
# Fail cleanly if directory has no files
# *****************************************

# arg check
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

# valid directory check
if [ ! -d "$DIR" ]; then
	printf "Error: not a directory: %s \n" "$DIR">&2
	exit 3
fi

# readability check
if [ ! -r "$DIR" ]; then
	printf "Error: not readable: %s \n" "$DIR">&2
	exit 4
fi

NEWEST_FILE=$(find "$DIR" -maxdepth 1 -mindepth 1 -type f -printf '%T@ %p\n' | sort -nr | head -n 1)

# %T@ : epoch time  
# %p :  file name
# -n : numeric sort
# -r : reverse (largest first)

if [ -z "$NEWEST_FILE" ]; then
  printf "Error: No files found in %s\n" "$DIR" >&2
  exit 5
fi

# file with full path
printf "%s\n" "${NEWEST_FILE#* }"

# only file name
printf "%s\n" "$(basename "${NEWEST_FILE#* }")"

# From the start of the string, remove everything up to and including the first space.
# ${NEWEST_FILE#* }
# I learned this today. I didn't learn it well. 

# ${var#pattern} = remove the shortest match of pattern from the start. 

# when you do this ${var#pattern} -> single # is short matching (match as little as you can, 
# like if you get one match,return immediately)

# when you do this ${var##pattern} -> double # is longgg matching. (meaning match as much as you can
# and then return)

# Example:
var="/a/b/c/file.txt"

printf "***************************************** \n"
printf "%s\n" "${var#*/}"
# b/c/file.txt (matched once, returned)

printf "%s\n" "${var##*/}" # basename internal logic
# file.txt (matched as lonf as posiible then returned)

# same version cuts from the right with % and %%.

