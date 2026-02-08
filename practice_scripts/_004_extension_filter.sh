#!/usr/bin/env bash

set -euo pipefail

#************************************************
# Extension filter								
# Input: directory + extension (e.g. .log)		
# Print only matching files (non-recursive)		
# Must handle filenames with spaces				
#************************************************

# restricting arguments to two (dir + extension)
if [ $# -ne 2 ]; then
	printf "Usage: %s <directory-path> <extension> \n" "$0">&2
	exit 1
fi

DIR="$1"
EXT="$2"

# path not valid check
if [ ! -e "$DIR" ]; then
	printf "Error: Path does not exist: %s \n" "$DIR">&2
	exit 2
fi

# is it directory check
if [ ! -d "$DIR" ]; then
	printf "Error: Not a valid directory: %s \n" "$DIR">&2
	exit 3
fi

# readability check
if [ ! -r "$DIR" ]; then
	printf "Error: Dirctory does not have read permission: %s \n" "$DIR">&2
	exit 4
fi

found=false

while read -r -d '' file; do
	printf "%s\n" "$file"
	found=true
done< <(find "$DIR" -maxdepth 1 -mindepth 1 -type f -name "*$EXT" -print0)

if [ "$found" = false ]; then
 	prinf "Error: No files exist in %s with %s extension" "$DIR" "$EXT">&2
	exit 5
fi	

# EXT_FIRST_CHAR="${EXT:0:1}"

# #if [ EXT_FIRST_CHAR -eq "." ]; then


# FILE_COUNT=$(find "$DIR" -maxdepth 1 -mindepth 1 -type f -name "*.$EXT" | wc -l)

# # file count is zero
# if [ "$FILE_COUNT" -eq 0 ]; then
# 	printf "Warning: No file matched with given extension: %s under %s \n" "$EXT" "$DIR">&2
# 	exit 5
# else
# 	find "$DIR" -maxdepth 1 -mindepth 1 -type f -name "*.$EXT" -print
# fi