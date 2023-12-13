#!/bin/bash

# Create and go to a temporary directory.
tmp() {
	cd $(mktemp -d)
}

# Duplicate file.
dupe() {
	if [ "$#" -lt 1 ]; then
		echo "Usage: dupe <file>"
		return 1
	fi

	file="$1"
	if [ ! -e "$file" ]; then
		echo "Error: $file not found"
		return 1
	fi

	counter=1
	while [ -e "${file}_$counter" ]; do
		counter=$((counter + 1))
	done

	file_duped="${file}_$counter"

	cp "$file" "$file_duped"

	echo "Copied $file -> $file_duped"
}

see() {
	query="$*"
	sdcv -n --color "$query" | sed "s/^/    /" | less -R
}


