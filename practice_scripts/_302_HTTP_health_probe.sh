#!/usr/bin/env bash

set -euo pipefail

#**********************************
# Input: URL
# Expect HTTP 200
# Fail if non 200 or timeout or network errors
#**********************************

TIMEOUT=5

# 1. Argument check
if [ "$#" -ne 1 ]; then
	printf "Usage: %s <url>\n" "$0" >&2
	exit 1
fi

URL="$1"

# 2. dependency check
if ! command -v curl >/dev/null 2>&1; then
	printf "Error: curl is required\n" >&2
	exit 2
fi

# 3. Perform request
# Explanation : 
# 	--silent: suppreses progress bar and normal ouput noises
#	--show-error: reenbles error messages even after silent.
#	so even though normal output is suppressed but errors are 
#	still visible.
#	--output /dev/null: discard json response, we only care 
#	about status code
#	--write-out "${http_code}": prints only the status code.
#	write-out uses curl predefined placeholder http_code to 
#	return status code. 	
HTTP_CODE="$(
	curl \
		--silent \
		--show-error \
		--output /dev/null \
		--write-out "%{http_code}" \
		--max-time "$TIMEOUT" \
		"$URL"
)"

# 4. Validate response
if [ "$HTTP_CODE" -eq 200 ]; then
	printf "Healthy: %s return HTTP 200\n" "$URL"
	exit 0
else
	printf "Unhealthy: %s returned HTTP %s\n" "$URL" "$HTTP_CODE" >&2
	exit 3
fi