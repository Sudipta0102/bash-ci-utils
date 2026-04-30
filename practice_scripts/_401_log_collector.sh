#!/usr/bin/env bash

set -euo pipefail

#**************************************
# Input: directory
# Collect all .log files into a timestamped folder
# fail if no logs found (avoiding silent success) 
#**************************************

# Note: I only checked path, directory and readability and
# regular file check which is done inside find command
# which is enough for this.
# 	But in production, some more checks should make it more
# defensive and less optimistic, like symlink check (-L), file size 
# not 0 check (-s) because sometimes file gets created but not written
# inside it because of permission, executable check (-x)
# Chronology should be like this:
# -e, -d, -L, -x, -r at first
# -f check inside find
# -s check when copying the cotent to the timestamped folder.

# 1. arg check
if [  ]; then
	printf "Usage: %s <directory>\n" "$0" >&2
	exit 1
fi

DIR="$1"

# 2. validate the directory
if [ ! -e "$DIR" ]; then
	printf "Error: Not a valid directory (Path doesn't exist): %s\n" "$DIR" >&2
	exit 2
fi

if [ ! -d "$DIR" ]; then
	printf "Error: Not a directory: %s\n" "$DIR" >&2
	exit 3
fi

if [ ! -r "$DIR" ]; then
	printf "Error: Directory not readable: %s\n" "$DIR" >&2
	exit 4
fi

# 3. find log files in a non recursive way
LOG_FILES=()
while IFS= read -r -d '' file; do
	LOG_FILES+=("$file")
done< <(find "$DIR" -maxdepth 1 -type f -name "*.log" -print0) || true

if [ "${#LOG_FILES[@]}" -eq 0 ]; then
	printf "Error: In %s no log files present\n" "$DIR" >&2
	exit 5
fi

# 4. creating a timestamped folder to store the log files.
TIMESTAMP="$(date +%y%m%d_%H%M%S)"
OUTPUT_DIR="$DIR/logs_$TIMESTAMP"

mkdir -- "$OUTPUT_DIR"

# 5. copy the log files into timestamped folder
for file in "${LOG_FILES[@]}"; do
	cp -- "$file" "$OUTPUT_DIR"
done

printf "Collected %d log files into %s\n" "${#LOG_FILES[@]}" "$OUTPUT_DIR"
exit 0
