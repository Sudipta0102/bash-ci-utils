#!/usr/bin/env bash

set -euo pipefail



# as of now, if number of args is not equal to 1 , it exits
# if [ $# -ne 1 ]; then
# 	printf 'Usage: %s <directory-path>\n' "$0" >&2
# 	exit 1	
# fi

# it's called Parameter Expansion with a Default Value.
# Give me the value of the first argument, but if it is empty or missing, use a dot (the current directory) instead.
DIR="${1:-.}"
OUTPUT_FILE="/mnt/c/Users/hp/VscodeProjects/project_code_bundle.txt"

if [ ! -d "$DIR" ]; then
	printf 'Error: %s is not a directory\n' "$DIR" >&2
	exit 2
fi

# clear or create an output file
> "$OUTPUT_FILE"

printf 'Success: Validated directory: %s\n' "$DIR"

#find "$DIR" \( -name ".*" -o -name "README.md" -o -name "LICENSE" -o -name "node_modules" -o -name "docs" -o -name "playwright-report" \) -prune -o -type f -print

# 1. Define all global ignore folders/files (IDEs, Package Managers, Virtual Envs)
EXCLUDES=(
	# Hidden IDE folders
	".git" ".vscode" ".idea" ".settings" ".pytest_cache" ".git*"

	# dependencies/ libraries
	"node_modules" "vendor" ".venv" "venv" "env" "target" "bin" "build" "dist" "playwright-report"
	"test-results"

	# specific project files
	"*.md" "LICENSE" ".editorconfig" "package-lock.json" "pnpm-lock.yaml" "yarn.lock"

	# environment files & secret files (.env, .env.example, .env.prod)
	".env*"
)

FIND_ARGS=()

for item in "${EXCLUDES[@]}"; do
	if [ -e "$DIR/$item" ] || compgen -G "$DIR/$item" >/dev/null 2>&1; then
		if [ "${#FIND_ARGS[@]}" -gt 0 ]; then
			FIND_ARGS+=("-o")
		fi
		FIND_ARGS+=("-name" "$item")
	fi	
done

printf "Items in find_arg: %s \n" "${FIND_ARGS[*]}"

# function to process the files and build the text files
bundle_files() {
	# I have used this before too, 
	# -r handles backlash escapes, -d $'-n' spaces in filename safely
	# while IFS= read -r -d $'\n' filepath; do
	while IFS= read -r -d '' filepath; do

		# If $DIR is "/mnt/c/project", this turns 
		# "/mnt/c/project/src/main.ts" into "src/main.ts"
		relative_path="${filepath#$DIR/}"

		printf "Bundling: %s \n" "$relative_path"

		# append the file path header
		printf "\n==========================================\n" >> "$OUTPUT_FILE"
		printf "FILE: %s\n" "$relative_path" >> "$OUTPUT_FILE"
		printf "\n==========================================\n" >> "$OUTPUT_FILE"

		# append the code inside the file
		cat "$filepath" >> "$OUTPUT_FILE"
		# next file starts from new line
		printf "\n" >> "$OUTPUT_FILE"
	done
}

# why cd "$DIR", and followed by "find . rest_of_the_command", 
# as opposed to no cd command and followed by "find "$DIR" rest_of_the_command",
# because I want to print the relative path on the file.
# 
cd "$DIR"

# Execute find and strream the paths safely using print0
if [ "${#FIND_ARGS[@]}" -gt 0 ]; then

	find . \( "${FIND_ARGS[@]}" \) -prune -o -type f -print0 | bundle_files

else

	find . -type f -print0 | bundle_files

fi

