#!/usr/bin/env bash

set -euo pipefail

# File existence & size checker
# Input: file path
# Print size in bytes
# Fail if file does not exist or is empty

# one arg only check
if [ $# -ne 1 ]; then
	printf "Usage: %s <file-path> \n" "$0">&2
	exit 1
fi

FILE="$1"

# file existence check
if [ ! -e "$FILE" ]; then
	printf "Error: %s does not exist \n" "$FILE">&2
	exit 2
fi

# file check
if [ ! -f "$FILE" ]; then
	printf "Error: %s is not a file \n" "$FILE">&2
	exit 3
fi

# empty file check
if [ ! -s "$FILE" ]; then
	printf "Error: %s is empty \n" "$FILE">&2
	exit 4
fi

# get the size in bytes
stat -c %s "$FILE"
