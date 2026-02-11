#!/usr/bin/env bash

set -euo pipefail

# **************************************
# Input: directory
# Output:
# 	files: X
# 	directories: Y
# 	symlinks: Z
# **************************************

# there seven types of file in this filesystem.
# 1. directory 
# 2. file
# 3. symlink
# 4. block device file (like a HDD)
# 5. socket file
# 6. character device file
# 7. named pipe file

# arg check

if [ $# -ne 1  ]; then
	printf "Usage: %s <directory-path> \n" "$0">&2
	exit 1
fi

DIR="$1"

if [ ! -e "$DIR" ]; then
	printf "Error: not a valid path: %s \n" "$DIR">&2
	exit 2
fi  

if [ ! -d "$DIR" ]; then
	printf "Error: not a directory: %s \n" "$DIR">&2
	exit 3
fi

if [ ! -r "$DIR" ]; then
	printf "Error: not readable: %s \n" "$DIR">&2
	exit 4
fi

COUNT_FILE=0
COUNT_DIRECTORY=0
COUNT_SYMLINK=0
COUNT_BLOCK=0
COUNT_SOCKET=0
COUNT_PIPE=0
COUNT_CHARACTER=0
ALL_COUNT=0

# this ordering is important symlink check should come first. 
# or symlink which is directory will register as directory not symlink.
while read -r -d '' file; do

	((ALL_COUNT++))

	if [ -L  "$file" ]; then
		((COUNT_SYMLINK++))
	elif [ -d "$file" ]; then
		((COUNT_DIRECTORY++))
	elif [ -f "$file" ]; then
		((COUNT_FILE++))
	elif [ -p "$file" ]; then
		((COUNT_PIPE++))
	elif [ -S "$file" ]; then
		((COUNT_SOCKET++))
	elif [ -b "$file" ]; then
		((COUNT_BLOCK++))
	elif [ -c "$file" ]; then
		((COUNT_CHARACTER++))				
	fi
done< <(find "$DIR" -maxdepth 1 -mindepth 1 -print0) || true

if [ "$ALL_COUNT" = 0 ]; then
	printf "Error: Empty folder: %s \n" "$DIR">&2
	exit 5
fi

printf "all count : %s \n" "$ALL_COUNT"

printf "symlink count : %s \n" "$COUNT_SYMLINK"
printf "file count : %s \n" "$COUNT_FILE"
printf "directory count : %s \n" "$COUNT_DIRECTORY"
printf "pipe count : %s \n" "$COUNT_PIPE"
printf "block device count : %s \n" "$COUNT_BLOCK"
printf "socket count : %s \n" "$COUNT_SOCKET"
printf "character device count : %s \n" "$COUNT_CHARACTER"



# Without set -e:
# 	EOF just ends the loop
# 	Script continues

# With set -e:
# 	Any non-zero status outside conditionals aborts the script

# read is the last command evaluated in the loop condition → fatal under -e.

# GENERAL RULE: Any while read loop under set -e must neutralize EOF. so doing || true