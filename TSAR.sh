#!/bin/sh

# Install a regular package
pkg_install() {
	if sudo pacman -S --noconfirm --needed "$1" >/dev/null 2>&1; then echo "done";
	else error "$1"; fi
}

# Install a package from the AUR
aur_install() {
	if trizen -S --noconfirm --needed "$1" >/dev/null 2>&1; then echo "done";
	else error "$1"; fi
}

# Install a python package
pip_install() {
	if sudo pip3 install "$1" >/dev/null 2>&1; then echo "done";
	else error "$1"; fi
}

# Print an error message and writes to the log file
error() {
	echo "ERROR - Written to log file"
	echo "$1 was unable to be installed" >> log.txt
}

# Install prerequisite software for installation
init_setup() {
	# Install base-devel, git, and pip
	printf "%s" "[Setup] Installing base-devel : tools required for package building... "; pkg_install base-devel
	printf "%s" "[Setup] Installing git : version control software... "; pkg_install git
	printf "%s" "[Setup] Installing pip : python package manager... "; pkg_install python-pip

	# Install trizen manually from the AUR
	printf "%s" "[Setup] Installing trizen : an AUR helper... "
	if ! [ -x "$(command -v trizen)" ]; then
		git clone https://aur.archlinux.org/trizen.git >/dev/null 2>&1
		cd trizen && makepkg --noconfirm --needed -si >/dev/null 2>&1
		cd .. && rm -rf trizen
	fi
	echo "done"
}

# Install initial programs, and everything listed in the csv
prog_install() {
	# Perform initial setup, and count number of programs to be installed
	init_setup
	total=$(($(wc -l < progs.csv) - 1))

	# Read in the CSV, discarding the opening line
	{ read -r
	while IFS=, read -r tag program comment; do
		# Increment the counter for the current program
		n=$((n+1))

		# Strip the comments carriage return
		comment=$(echo "$comment" | sed -e 's/\r//g')

		# Display a status message for the respective install
		printf "%s" "[$n/$total] $program : $comment... "

		# Execute the appropriate install for the program
		case "$tag" in
			"A") aur_install "$program";;
			"P") pip_install "$program";;
			*) pkg_install "$program";;
		esac
	done } < progs.csv
}



# TODO
dotfiles() {
	git -C /tmp clone https://github.com/Twalaght/dotfiles
	# cp -r /tmp/dotfiles/.config $HOME/Hamburger
	# cp -r /tmp/dotfiles/.scripts $HOME/Hamburger
	rm -rf /tmp/dotfiles
}


misc () {
	# Remove system beep from kernel load
	sudo cp misc/nobeep.conf /etc/modprobe.d

	# Enable a global gtk3 dark theme
	sudo cp misc/settings.ini /etc/gtk-3.0

	# Copy a libinput config to enable natural touchpad scrolling
	sudo cp misc/30-touchpad.conf /etc/X11/xorg.conf.d

	# TODO
	# pywal the given background when installing
}



# prog_install

# TODO - Could combine the two
# dotfiles
# misc

echo "Installation complete!"
