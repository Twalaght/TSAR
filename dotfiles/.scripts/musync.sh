#!/bin/bash

# TODO - Sync mp3 no parity too
# TODO - Playlist handling

source="/mnt/f/Media/Music"

rsync -av --ignore-existing -e "ssh -p 2222" "$source/FLAC/" twi@192.168.1.106:SDCard/Music/FLAC
# rsync -av --ignore-existing -e "ssh -p 2222" "$source/FLAC/" twi@192.168.1.106:SDCard/Music/FLAC