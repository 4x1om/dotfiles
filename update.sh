#!/bin/bash

# This script updates all dotfiles in the directory with dotfiles on the current system.

read -p "Update the repository with the dotfiles on this machine? (y/n): " response

# Accept Y or y
if [[ ! "$response" =~ ^[Yy]$ ]]; then
	echo Abort.
	exit 1
fi

# Find all files and directories starting with a dot, excluding .git.
# Output path directly (.bashrc, not ./.bashrc).
files=$(find . -mindepth 1 -type f -name ".*" -not -path "./.git/*" -printf "%P\n")
for file in $files; do
	if [[ ! -e ~/$file ]]; then
		echo "Skipping ~/$file: does not exist"
		continue
	fi
	if [[ ! ~/$file -nt ./$file ]]; then
		echo "Skipping ~/$file: not newer than current version"
		continue
	fi
	cp -p ~/$file ./$(dirname "$file")
	echo "Updated $file"
done
