#!/usr/bin/env bash

set -euo pipefail

# if the argument number is more than 1, then it exits
if [ $# -ne 1 ]; then
	# echo "Usage: $0 <directory-path>" >$2
	printf 'Usage: %s <directory-path>\n' "$0" >&2
	exit 1 
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
	printf 'Error: %s is not valid directory' "$DIR" >&2
	exit 2
fi

# this files all folder and files
#ls -la "$DIR"

# this gives only files
# find "$DIR" -maxdepth 1 -type f -print

# just a note: onnly -type f without maxdepth wont do because it will recursively check 
# all folders inside the given folder. Maxdepth 1 gives immediate files
# of the folder.

# to find all contents in immediate sub folder:
# find "$DIR" -maxdepth 1 -print

# recursive find to list sub and sub sub and so on folders
find "$DIR" -print