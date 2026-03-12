#!/usr/bin/env bash

set -euo pipefail

# ***************************************
# Timeout runner
# Input: command + seconds
# Kill command if it exceeds time
# Exit with a distinct timeout code
# ***************************************

TIMEOUT_EXIT_CODE=124

# arugments count check
if [ $# -lt 2 ]; then
	printf "Usage: %s <timeout-in-seconds> <command> <args...>" "$0">&2
	exit 1
fi

TIMEOUT="$1"
shift

# timeout in seconds should be a positive integer
if ! [[ "$TIMEOUT" =~ ^[0-9]+$ ]] || [ "$TIMEOUT" -lt 1 ]; then
	printf "Error: Timeout: %s is invalid, should be positive integer" "$TIMEOUT">&2
	exit 2
fi

# run command in the background
# & runs the command in the background
"$@" &
CMD_PID=$!

(
	sleep "$TIMEOUT"

	if kill -0 "$CMD_PID" 2>/dev/null; then
		kill -TERM -- "-$CMD_PID" 2>/dev/null || true
	fi 

) &
WATCHDOG_PID=$!

# wait for command to finish
if wait "$CMD_PID"; then
  EXIT_CODE=0
else
  EXIT_CODE=$?
fi

# stop watchdog if command finished early
kill "$WATCHDOG_PID" 2>/dev/null || true
wait "$WATCHDOG_PID" 2>/dev/null || true

# detect timeout
if [ "$EXIT_CODE" -eq 143 ]; then
  # 143 = terminated by SIGTERM (128 + 15)
  printf "Command timed out after %s seconds\n" "$TIMEOUT" >&2
  exit "$TIMEOUT_EXIT_CODE"
fi

exit "$EXIT_CODE"


# for (( i=0; i<=TIMEOUT; i++ )); do
# 	echo "inside for loop"

# 	if "$@"; then
# 		printf "SUCCESS: %s is executed succesfully before timeout" "$@"
# 		exit 0
# 	else
# 		sleep 1
# 	fi

# done

# PID=$!

# kill "$PID"



