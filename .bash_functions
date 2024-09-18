#!/bin/bash

# Echo $PATH, separated by \n
path() {
	echo $PATH | sed "s/:/\n/g"
}

# `cd` then `ls`. If called without arguments, it equals a raw `ls`.
cl() {
	cd "$1" && ls
}

# `mkdir` then `cl`.
mkcl() {
	mkdir "$1" && ls "$1"
}

# `cd` then `la`.
ca() {
	cd "$1" && ls -A
}

# Create and go to a temporary directory.
tmp() {
	cd $(mktemp -d)
}

# Duplicate file or directory and add a counter at the end.
# If called with 2 parameters, it's equivalent to cp -r.
dupe() {
	if [ "$#" -lt 1 ]; then
		echo "Usage: dupe <path> [<target>]"
		return 1
	fi

	path="$1"
	if [ ! -e "$path" ]; then
		echo "dupe: $path not found"
		return 1
	fi

	if [ "$#" -ge 2 ]; then
		path_duped="$2"
	else
		counter=1
		while [ -e "${path}_$counter" ]; do
			counter=$((counter + 1))
		done
		path_duped="${path}_$counter"
	fi

	cp -r "$path" "$path_duped" && echo "Duplicated $path -> $path_duped"
}

# Look up in sdcv
# Dependency: apt sdcv
see() {
	query="$*"
	# The sed command adds 4 spaces before each line
	sdcv -n --color "$query" -u "Webster's Revised Unabridged Dictionary (1913)" \
		-u "Collins Cobuild English Dictionary" \
		-u "WordNet" | sed "s/^/    /" | less -R
}

# Check synonyms
syn() {
	query="$*"
	# The sed command adds 4 spaces before each line
	sdcv -n --color "$query" -u "Moby Thesaurus II" | sed "s/^/    /" | less -R
}

# Search on jisho.org
# Dependency: npm jisho-cli
miru() {
	query="$*"
	jisho-cli -c always -r "$query" | less -R
}
