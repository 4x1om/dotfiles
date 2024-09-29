#!/bin/bash

# This script sets up a development environment on a new machine.

abort() {
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

ask_question() {
	read -p "$1 (y/n) " response
	if [[ "$response" =~ ^[Yy]$ ]]; then
		echo "yes"
	else
		echo "no"
	fi
}

setup_dotfiles() {
	core=(
		.bashrc
		.inputrc
		.bash_logout
		.vimrc
		.gitconfig
		.lesskey
	)
	echo "Symlinking core dotfiles..."
	make_symlinks "${core[@]}"

	linux_input=(
		.Xmodmap
		.imwheelrc
	)
	copy_linux_input=$(ask_question "Copy Linux input configuration dotfiles?")
	if [[ $copy_linux_input == "yes" ]]; then
		make_symlinks "${linux_input[@]}"
	fi
}

admin_tasks() {
	upgrade_apt=$(ask_question "Upgrade apt?")
	install_base=$(ask_question "Install a basic set of apt programs?")
	install_nvm=$(ask_question "Download nvm?")
	install_vim_plug=$(ask_question "Download vim-plug and install vim plugins?")

	sudo apt update
	if [[ $upgrade_apt == "yes" ]]; then
		sudo apt upgrade -y
	fi
	if [[ $install_base == "yes" ]]; then
		base=(
			neofetch
			trash-cli
			sdcv
		)
		sudo apt install -y ${base[@]}
	fi
	if [[ $install_nvm == "yes" ]]; then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
	fi
	if [[ $install_vim_plug == "yes" ]]; then
		# Download vim-plug and install plugins.
		# See https://github.com/junegunn/vim-plug/wiki/tutorial
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		# Enter vim, run :PlugInstall and immediately quit.
		vim -c PlugInstall -c qa!
	fi
}

echo "This script sets up a development environment on a new machine."
echo "The dotfiles on the current machine will be overriden."
do_continue=$(ask_question "Are you sure you want to continue?")
if [[ $do_continue == "no" ]]; then
	abort
fi
with_sudo=$(ask_question "Do you have sudo access?")

setup_dotfiles
if [[ $with_sudo == "yes" ]]; then
	admin_tasks
fi

echo "Setup complete."
exit 0
