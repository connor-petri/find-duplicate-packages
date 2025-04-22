#!/bin/bash

filepaths=()
declare -A matchpaths

# $1 = dir path
function search_dir {
	echo "Searching directory: $1"

	for file in "$1"/*.package; do
		if [ ! -f "$file" ]; then
			continue
		fi

		# Search filepaths for name duplicates
		for f in "${filepaths[@]}"; do
			if [ "$(basename "$f")" == "$(basename "$file")" ]; then
				matchpaths["$f"]="$file"
			fi
		done
		
		# Add file to filepaths array
		filepaths+=("$file")
	done

	for dir in "$1"/*; do
		if [ ! -d "$dir" ]; then
			continue
		fi
		search_dir "$dir"
	done
}

# Ensure a directory is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Start searching for duplicates
search_dir "$1"

echo -----------------------------------

# Output matches
if [ ${#matchpaths[@]} -eq 0 ]; then
    echo "No duplicates found."
else
    for key in "${!matchpaths[@]}"; do
        echo "Duplicate: $key --- ${matchpaths[$key]}"
    done
fi
