#!/usr/bin/env bash
# Clean up user's ByHost Preferences on OS X
set -eu
shopt -s extglob

cd ~/Library/Preferences/ByHost

hostUUID=$(ls -t *.plist | head -1 | sed 's/\.plist$//; s/.*\.//')
read -p "This host's UUID detected as: $hostUUID"$'\n'"Correct? "
echo

if ls -d !(*."$hostUUID".plist*|Attic) 2>/dev/null; then
    read -p "$(ls -d !(*."$hostUUID".plist*|Attic) | wc -l) obsolete files above to archive."$'\n'"Correct?"
    echo

    dest=~/Library/Preferences.obsolete/ByHost
    mkdir -p "$dest"
    mv -v !(*."$hostUUID".plist*|obsolete.*) "$dest"/

    echo "All obsolete preferences data have been moved to $dest"
else
    echo "Your preferences folder is clean!  No obsolete data"
fi
