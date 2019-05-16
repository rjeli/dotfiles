#!/bin/bash

function prompt {
	while true; do
		read -p "$1 " yn
		case $yn in
			[Yy]* ) return 0;;
			[Nn]* ) return 1;;
			* ) echo "please answer yes or no";;
		esac
	done
}

function link {
	src="$1"
	dst="$2"
	rm "$dst"
	ln -s `readlink -e "$src"` "$dst"
}

function add {
	src="$1"
	dst="$2"
	if [ -f "$dst" ]; then
		src_full=`readlink -e "$src"`
		dst_full=`readlink -e "$dst"`
		if [ "$dst_full" = "$src_full" ]; then
			echo "$src is already linked"
		else
			echo "$dst already exists, the diff is:"
			diff "$src" "$dst"
			if prompt "would you like to replace it? (y/n)"; then
				link "$src" "$dst"
			fi
		fi
	else
		link "$src" "$dst"
	fi
}

add vimrc $HOME/.vimrc
add gitconfig $HOME/.gitconfig

