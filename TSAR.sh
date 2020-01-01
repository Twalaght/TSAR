#!/bin/sh

##TODO Wrap installs into 1 func


# Displays menus to guide the user through installation
menus() {
	# Intro message to TSAR
	clear
	if ! dialog --title "TSAR" --yesno "Welcome to TSAR - Twa's Scripted Auto Rice\\n\\nThis script will automatically install an up to date, i3-gaps Arch Linux rice.\\n\\nOptionally, program installation or dotfile merging can be omitted" 12 50; then
		clear
		exit
	fi

	# Gives the user the option of which parts to run
	edition="$(dialog --title "TSAR method" --menu "Select what you wish TSAR to do to your system:" 10 60 2 programs "Only install programs" files "Only copy dotfiles" both "Install programs and copy dotfiles" 3>&1 1>&2 2>&3 3>&1 && exit)" 
	clear
}

# Installs a standard package with pacman
packageinstall() {
	if sudo pacman --noconfirm --needed -S "$1" >/dev/null 2>&1; then
		echo "done"
	else
		error "$1"
	fi
}

# Installs AUR packages with trizen
aurinstall() {
	if trizen -S --noconfirm --needed "$1" >/dev/null 2>&1; then
		echo "done"
	else
		error "$1"
	fi
}

# Installs python packages with pip
pipinstall() {
	if sudo pip3 install "$1" >/dev/null 2>&1; then
		echo "done"
	else
		error "$1"
	fi
	
}

# Logs programs that trigger errors when installing
error() {
	echo "ERROR - Written to log file"
	echo "$1" was unable to be installed >> log
}

# Copies TSARs dotfiles
dotfiles() {

}

# Installs TSARs set of programs
proginstall() {
	# Counts the total number of programs to be installed
	total=$(($(wc -l < progs.csv) - 1))

	# Iterates through the csv, discarding the opening line
	{ read -r
	while IFS=, read -r tag program comment; do
		# Number of the current program being installed
		n=$((n+1))
		
		# Remove the carriage return from the comment
		comment=$(echo "$comment" | sed -e 's/\r//g')

		# Displays the progress on installation
		#echo -n "[$n/$total] $program : $comment... "
		printf "%s" "[$n/$total] $program : $comment... "

		# Runs the installation command based on the tag
		case "$tag" in
			"A") aurinstall "$program" "$comment" ;;
			"P") pipinstall "$program" "$comment" ;;
			*) packageinstall "$program" "$comment" ;;
		esac
	done } < progs.csv
}


menus

if [ -z "$edition" ]; then
	exit
elif [ "$edition" = both ]; then
	dotfiles
	proginstall
elif [ "$edition" = files ]; then
	dotfiles
elif [ "$edition" = programs ]; then
	proginstall
fi

echo
echo "Installation complete!"