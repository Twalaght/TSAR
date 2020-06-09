#!/bin/sh

# Clone the TSAR repo containing the scripts
git -C /tmp clone --quiet https://github.com/Twalaght/TSAR
# Copy the scripts folder to home
cp -r /tmp/TSAR/dotfiles/.scripts ~
# Remove the temp repo
rm -rf /tmp/TSAR