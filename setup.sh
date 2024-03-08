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
		echo TARGET BE LIKE $target
		# -f: [f]orce remove destination file if exists
		ln -sf "$target" ~
	done

}

symlinks() {

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

	make_symlinks "${core[@]}"

	linux=(
		.Xmodmap
		.imwheelrc
	)

	read -p "Set up Linux input configurations? (y/n) " response

	# Accept Y/y
	if [[ "$response" =~ ^[Yy]$ ]]; then
		make_symlinks "${linux[@]}"
	fi

}

setup() {
	echo "Updating apt..."
	sudo apt update && sudo apt upgrade -y

	# Download Node.js from source.
	# See https://askubuntu.com/a/83290
	read -p "Download the latest version of Node.js? (y/n)" response

	if [[ "$response" =~ ^[Yy]$ ]]; then
		curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
		sudo apt-get install -y nodejs
	fi

	# Download vim-plug and install plugins.
	# See https://github.com/junegunn/vim-plug/wiki/tutorial
	echo "Downloading vim-plug..."
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	# Enter vim, run :PlugInstall and immediately quit
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
}

echo "Dotfiles management."
echo "1: Set up only symlinks (This removes all dotfiles on the current machine. Irreversible!)"
echo "2: Set up entire development environment"
echo "Anything else: Abort"
read -p "Your choice (1/2): " response

case $response in
	1)
		symlinks
		;;
	2)
		symlinks
		setup
		;;
	*)
		abort
		;;
esac

echo "Completed."
exit 0
