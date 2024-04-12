#!/bin/bash

abort() {
	echo
	echo "Abort."
	exit 1
}

# When the user sends an interrupt signal (Ctrl+C),
# abort the script instead of skipping current command.
trap abort INT

# Create symlinks from array of filepaths, at ~
make_symlinks() {
	files=("$@")
	for file in "${files[@]}"; do
		target=$(realpath "$file")
		# -f: [f]orce remove destination file if exists
		ln -sf "$target" ~
	done
}

without_sudo() {
	core=(
		.bashrc
		.aliases
		.exports
		.bash_functions
		.bash_logout
		.vimrc
		.gitconfig
		.lesskey
	)

	echo "Copying core dotfiles..."
	make_symlinks "${core[@]}"

	linux=(
		.Xmodmap
		.imwheelrc
	)

	read -p "Copy Linux input configuration dotfiles? (y/n) " response
	if [[ "$response" =~ ^[Yy]$ ]]; then
		make_symlinks "${linux[@]}"
	fi
}

with_sudo() {
	read -p "Upgrade apt? (y/n) " response
	if [[ "$response" =~ ^[Yy]$ ]]; then
		sudo apt update && sudo apt upgrade -y
	fi

	# Download Node.js from source.
	# See https://askubuntu.com/a/83290
	read -p "Download the latest version of Node.js? (y/n) " response

	if [[ "$response" =~ ^[Yy]$ ]]; then
		curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
		sudo apt-get install -y nodejs
	fi

	read -p "Download vim-plug? (y/n) " response
	if [[ "$response" =~ ^[Yy]$ ]]; then
		# Download vim-plug and install plugins.
		# See https://github.com/junegunn/vim-plug/wiki/tutorial
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		# Enter vim, run :PlugInstall and immediately quit
		vim -c PlugInstall -c qa!
	fi

	# Compile YouCompleteMe. This may take a long time, so an option is offered to skip.
	# See https://github.com/ycm-core/YouCompleteMe/blob/master/README.md#linux-64-bit
	read -p "Compile YouCompleteMe now? (y/n) " response

	if [[ "$response" =~ ^[Yy]$ ]]; then
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
}

echo "This script will make irreversible changes to this machine. Enter your action:"
echo "su: Set up dev environment assuming you have sudo privileges."
echo "dev: Set up dev environment without sudo privileges."
read -p "Your choice: " response

case $response in
	dev)
		without_sudo
		;;
	su)
		without_sudo
		with_sudo
		;;
	*)
		abort
		;;
esac

echo "Setup complete."
exit 0
