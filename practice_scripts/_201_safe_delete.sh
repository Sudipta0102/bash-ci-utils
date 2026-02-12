#!/usr/bin/env bash

set -euo pipefail

# ********************************************
# Safe delete
# Input: file path
# Refuse to delete:
#     /
#     empty variable
#     non-regular files
# Print what would be deleted before doing it
# ********************************************

# arg count check
if [ $# -ne 1 ]; then
    printf "Usage: %s <file-path> \n" "$0">&2
    exit 1
fi

FILE="$1"

if [ -z "$FILE" ]; then
    printf "Error: empty argument deletetion not allowed: %s \n" "$FILE">&2
    exit 2
fi

#CANONICAL_PATH="$(realpath -- "$FILE")" 

if ! CANONICAL_PATH="$(realpath -- "$FILE")"; then
    printf "Error: cannot resolve path: %s\n" "$FILE" >&2
    exit 3
fi

# this is root protection mainly  
if [ "$CANONICAL_PATH" = "/" ]; then
    printf "Error: Not a safe delete: %s \n" "$FILE">&2
    exit 4
fi

# if symlink, do not delete
if [ -L "$CANONICAL_PATH" ]; then
    printf "Error: symlink deletion not allowed: %s \n" "$FILE">&2
    exit 5
fi

# file or not
if [ ! -f "$CANONICAL_PATH" ]; then
    printf "Error: not a valid file: %s \n" "$FILE">&2
    exit 6
fi

# audit trail (must happen before deletion)
printf "Deleting: %s\n" "$CANONICAL_PATH" >&2

# delete
rm -- "$CANONICAL_PATH"







# read -p "Are you sure about deleting $CANONICAL_PATH? [y/n]" -n 1 -r REPLY

# if [[ $REPLY =~ ^[Yy]$ ]]; then
#     # verbose delete and stderr/stdout 
#     rm -v "$CANONICAL_PATH" 2>&1
# else
#     printf "%s not deleted" "$CANONICAL_PATH"
#     exit 8
# fi

