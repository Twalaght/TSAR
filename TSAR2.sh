#!/bin/sh

# Install a regular package
pkg_install() {
	if sudo pacman -S --noconfirm --needed "$1" >/dev/null 2>&1; then echo "done";
	else error "$1"; fi
}

# Install a package from the AUR
pkg_install() {
	if trizen -S --noconfirm --needed "$1" >/dev/null 2>&1; then echo "done";
	else error "$1"; fi
}


# TODO - Enable logging
# Prints an error message and writes to the log file
error() {
	echo "ERROR - Written to log file"
	echo "$1 was unable to be installed" >> log.txt
}



# Installs prerequisite software for installation
init_setup() {
	# Installs base-devel and git
	printf "%s" "[Setup] Installing base-devel : tools required for package building... "; pkg_install base-devel
	printf "%s" "[Setup] Installing git : version control software... "; pkg_install git

	# Installs trizen manually from the AUR
	printf "%s" "[Setup] Installing trizen : an AUR helper... "
	if ! [ -x "$(command -v trizen)" ]; then
		git clone https://aur.archlinux.org/trizen.git >/dev/null 2>&1
		cd trizen && makepkg --noconfirm --needed -si >/dev/null 2>&1
		cd .. && rm -rf trizen
	fi
	echo "done"
}

# TODO
prog_install() {
	init_setup

	total=$((wc -l < progs.csv) - 1))



	{ read -r
	while IFS=, read -r tag program comment; do
		n=$((n+1))

		comment=$(echo "$comment" | sed -e 's/\r//g')

	done } < progs.csv
}



pkg_install git
pkg_install kitty
pkg_install kekemishter
pkg_install gcc
