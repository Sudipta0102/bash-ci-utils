#!/usr/bin/env bash

set -euo pipefail

#*************************************
# Required env vars passed as arguments
# Fail fast if any are missing or empty
# Print missing ones
#*************************************

# 1. Argument check, need atleast one var
if [ "$#" -lt 1 ]; then
	printf "Usage: %s <ENV_VAR> [ENV_VAR...]\n" "$0" >&2
	exit 1
fi

MISSING=0


# Command Explanation:
# 	if [ -z "${!VAR_NAME:-}" ]: 
#	-z: checks something is empty or not
#	
#	${!VAR_NAME} : indirect expansion, it returns whatever values
#	are assigned to the values which is assigned to VAR_NAME
#	Example:
#		VAR_NAME="SERVICE_HOST"
#		SERVICE_HOST="localhost"
#		then, ${!VAR_NAME} returns "localhost"	
#	
#	${VAR_NAME:-} : meaning if the var is unset, use empty string.
#	because I used set -u, without :- this would crash because it 
#	will be unset otherwise leading to error.
for VAR_NAME in "$@"; do
	# 2. Check var is unset or empty
	if [ -z "${!VAR_NAME:-}" ]; then
		printf "Missing or empty var: %s\n" "$VAR_NAME" >&2
		MISSING=1
	fi
done

# 3. check for anything unset
if [ "$MISSING" -ne 0 ]; then
	exit 2
fi

# 4. when everything is set, exit with status 0
printf "All required env var are set\n"
exit 0