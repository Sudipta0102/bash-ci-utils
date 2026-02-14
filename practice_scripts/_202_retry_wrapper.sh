#!/usr/bin/env bash

set -euo pipefail

# *********************************************
# Retry wrapper
# Input: command + retry count
# Retry only on non-zero exit
# Preserve final exit code
# *********************************************

# arg count check
if [ $# -lt 2 ]; then
	printf "Usage: %s <retry-count> <command> [args...]\n" "$0">&2
	exit 1
fi

RETRY_COUNT="$1"
shift
# COMMAND_TO_RUN="$@" 
# storing "$@" in a variable loses argument boundaries, so it breaks commands with spaces or multiple arguments.
# If you need to store a command, store it as an array — never as a string.
# COMMAND_TO_RUN=( "$@" ) # storing it in array
# if "${COMMAND[@]}"; then -> preserves each element separately
# DO NOT use COMMAND[*] -> then it's same as storing it in a variable
EXIT_CODE=1

# check its a positive integer - the retry count
# [ "$RETRY_COUNT" =~ ^[0-9]+$ ] -> checks its a number or not
if ! [[ "$RETRY_COUNT" =~ ^[0-9]+$ ]] || [ "$RETRY_COUNT" -lt 1 ]; then
	printf "Error: retry count: %s is not positive integer\n" "$RETRY_COUNT">&2
	exit 2
fi


for (( i=1; i<=RETRY_COUNT; i++ )); do
	
	# executing the command
	if "$@"; then
		exit 0
	else
		EXIT_CODE=$?
		printf "Attempt %d/%d failed with exit code %d\n" "$i" "$RETRY_COUNT" "$EXIT_CODE" >&2
	fi

	# add delays here if you want...
done

printf "Command failed after %d attempts. Final exit code: %d\n" "$RETRY_COUNT" "$EXIT_CODE" >&2

exit "$EXIT_CODE"