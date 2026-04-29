#!/usr/bin/env bash

set -euo pipefail

# *************************************
# Port readiness check
# Input: host + port + timeout
# Wait until port is open or timeout
# Print how long it waited
# usage: 
# port-ready <host> <port> <timeout-seconds>
# *************************************

# what "port is open" means:
# A TCP connection to <host>:<port> succeeds.

# 1. argument validation
if [ "$#" -ne 3 ]; then
	printf "Usage: %s <host> <port> <timeout-seconds>\n" "$0">&2
	exit 1
fi

HOST="$1"
PORT="$2"
TIMEOUT="$3"

# 2. validate port(1-65535)
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ];then
	printf "Error: Invalid port: %s\n" "$PORT">&2
	exit 2
fi

# 3. validate timeout (positive integer)
if ! [[ "$TIMEOUT" =~ ^[0-9]+$ ]] || [ "$TIMEOUT" -lt 1 ]; then
	printf "Error: Timeout must be positive integer\n">&2
	exit 3 
fi

# 4. Check dependency
if ! command -v nc >/dev/null 2>&1; then
	printf "Error: 'nc'(netcat) is required\n" >&2
	exit 4
fi

START_TIME="$(date +%s)"

while true; do
	# 5. Attempting to connect
	if nc -z "$HOST" "$PORT" >/dev/null 2>&1; then
		NOW="$(date +%s)"
		ELAPSED=$(( NOW - START_TIME ))
		printf "Port %s:%s is ready after %s seconds\n" "$HOST" "$PORT" "$ELAPSED"
		exit 0
	fi

	NOW="$(date +%s)"
	ELAPSED=$(( NOW - START_TIME ))

	if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
		printf "Timeout after %s seconds waiting for %s:%s\n" "$TIMEOUT" "$HOST" "$PORT" >&2
		exit 5
	fi

	sleep 1
done