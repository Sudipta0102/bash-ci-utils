#!/usr/bin/env bash

set -euo pipefail

#*****************************************
# Input: directory
# Delet only known safe folders (tmp/, artifacts/)
# Also refuse to run outside git repo
#*****************************************

# 1. arg check
if [ "$#" -ne 1 ]; then
    printf "Usage: %s <directory>\n" "$0" >&2
    exit 1
fi

DIR="$1"

#-e, -d, -L, -x, -r

# 2. Path does not exist
if [ ! -e "$DIR" ]; then
	printf "Error: Path does not exist: %s\n" "$DIR" >&2
	exit 2
fi

# Later Note: I used realpath which follows all symlinks and gives
# us physical location if the directory. SO commenting this part. 
# 3. Symlink check
# if [ -L "$DIR" ]; then
# 	printf "Error: directory %s is a symlink" "$DIR" >&2
# 	exit 3
# fi

# realpath might not be avaible on every system. readlink -f 
# could be a good substitute. I am using realpath here. 
# I am not sure here. checking for the command is available would
# be an idea. 
# 3. cannonicalize directory
if ! BASE_DIR="$(realpath -e -- "$DIR")"; then
	printf "Error: Path %s does not exist 0r inaccessible\n" "$DIR" >&2
	exit 3
fi

# 4. Directory check
if [ ! -d "$BASE_DIR" ]; then
	printf "Error: Not a directory: %s\n" "$BASE_DIR" >&2
	exit 4
fi

# 5. readability check
if [ ! -r "$BASE_DIR" ]; then
	printf "Error: Directory %s does not have read access" "$BASE_DIR" >&2
	exit 5
fi

# 6. write check
if [ ! -w "$BASE_DIR" ]; then
	printf "Error: Directory %s does not have write access" "$BASE_DIR" >&2
	exit 6
fi

# 7. executable check
if [ ! -x "$BASE_DIR" ]; then
	printf "Error: Directory %s does not have execute access" "$BASE_DIR" >&2
	exit 7
fi

# 8. ensure inside a git repo
if ! git -C "$BASE_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	printf "Error: %s is not inside a git repo" "$BASE_DIR" >&2
	exit 8
fi

FOLDERS_TO_BE_DELETED=("tmp" "artifacts")

DELETED=0

for name in "${FOLDERS_TO_BE_DELETED[@]}"; do
	TARGET_FOLDER="$BASE_DIR/$name"

	if [ -d "$TARGET_FOLDER" ]; then
		printf "Deleting: %s\n" "$TARGET_FOLDER" >&2
		rm -rf -- "$TARGET_FOLDER"
		DELETED=1
	fi	
done

if [ "$DELETED" -eq 0 ]; then
	printf "No Folders to be deleted in %s\n" "$BASE_DIR" >&2
	exit 9
fi

printf "Folder or Workspace cleaned Successfully\n"
exit 0
