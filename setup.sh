#!/bin/bash

#
# This script sets up my dev environment on a new machine.
#

# Abort the script.
abort() {
	echo
	echo Abort.
	exit 1
}

read -p "This script overwrites dotfiles on the current machine. Proceed? (y/n) " response

# Accept Y or y
if [[ ! "$response" =~ ^[Yy]$ ]]; then
	abort
fi

# When the user sends an interrupt signal (Ctrl+C),
# abort the script instead of skipping current command.
trap abort INT

echo "Copying core dotfiles... "
cp -r ./.bashrc ./.bash ./.gitconfig ./.vimrc ~/

# Xmodmap and imwheel for Ubuntu.
read -p "Copy Linux input configurations? (y/n) " response

if [[ "$response" =~ ^[Yy]$ ]]; then
	cp ./.Xmodmap ./.imwheelrc ~/
fi

echo "Updating apt..."
sudo apt update

# Download vim-plug and install plugins.
# See https://github.com/junegunn/vim-plug/wiki/tutorial

echo "Downloading vim-plug..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Run :PlugInstall and quit
vim -c PlugInstall -c qa!

# Compile YouCompleteMe. This may take a long time, so an option is offered to skip.
# See https://github.com/ycm-core/YouCompleteMe/blob/master/README.md#linux-64-bit
read -p "Compile YouCompleteMe automatically? (y/n) " response

if [[ "$response" =~ ^[Yy]$ ]]; then
	echo "Setting up YouCompleteMe..."

	# Install CMake, Vim and Python
	sudo apt install build-essential cmake vim-nox python3-dev

	# Install mono-complete, go, node, java, and npm
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
	echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_current.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
	sudo apt install mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm

	# Compile YCM
	echo "Compiling YouCompleteMe..."
	cd ~/.vim/plugged/YouCompleteMe
	python3 install.py --all
fi

echo "Setup completed."
exit 0
