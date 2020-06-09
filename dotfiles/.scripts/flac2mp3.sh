#!/bin/bash

# TODO - Flags, and path not hardcoded

# Define the path for the FLAC and MP3 music folders
# fullpath="."
fullpath="/mnt/f/Media/Music"

# Determine which files are present in FLAC, but not in MP3
# Ignores album art, and sanitizes the output to be only file names
diff=$(diff <(find $fullpath/FLAC -type f -printf "%f\n" | sed -e '/^AlbumArt/d' -e 's/\.[^.]*$//') \
			<(find $fullpath/MP3 -type f -printf "%f\n" | sed -e '/^AlbumArt/d' -e 's/\.[^.]*$//') \
			| grep "<" | sed 's/< //')

# If no changes need to be made, exit the script
if [ -z "$diff" ]; then
	echo -e "\e[32mNothing to do!\e[39m"
	exit 0
fi

# Create MP3 copies of any files that do not already have one
while IFS= read -r name; do
	# Store the input and output paths to make ffmpeg less cluttered
	flac_song="$fullpath/FLAC/$name.flac"
	mp3_song="$fullpath/MP3/$name.mp3"

	# Print a status message
	printf "%s" "Converting $name... "

	# Convert each FLAC song to an MP3 copy
	if ffmpeg -i "$flac_song" -ab 320k -map_metadata 0 -id3v2_version 3 -nostdin -loglevel 0 "$mp3_song"; then 
		# Print a green "done" on success
		echo -e "\e[32mdone\e[39m"
	else
		# Print a red "ERROR" on failure
		echo -e "\e[31mERROR\e[39m"
	fi
done <<< "$diff"