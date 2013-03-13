#!/usr/bin/env bash
# synctex.skim-macvim.sh -- a script for Skim to MacVim PDF-TeX Sync support
# 
# Usage: From the Sync tab of Skim's Preference window,
#        1. Choose "Custom" Preset
#        2. Command:   /Users/netj/.vim/synctex.skim-macvim.sh
#        3. Arguments: "%file" %line /opt/homebrew/bin/mvim
#
# Author: Jaeho Shin <netj@cs.stanford.edu>
# Created: 2013-03-12
set -eu

# find the filename and line from arguments, or show usage
[ $# -ge 2 ] || { sed -n '2,/^#$/ s/^# //p' <"$0"; exit 1; }
file=$1 line=$2

# look for mvim
mvim=${3:-$(type -p mvim 2>/dev/null || bash -lc 'type -p mvim' 2>/dev/null)}

# get the servername from the title of MacVim (in the current space)
vimServer=$(
    osascript -e 'tell application "System Events"
        get title of first window of process "MacVim"
    end tell' 2>/dev/null | sed 's/.* - //'
)

# or, generate a new one
if [ -z "$vimServer" ]; then
    vimCount=$("$mvim" --serverlist | wc -l)
    if [[ $vimCount -eq 0 ]]; then
        vimServer=VIM
    else
        vimServer=$(seq $(($vimCount+1)) | sed 's/^/VIM/' |
            comm -23 - <("$mvim" --serverlist | sort) | head -n 1)
    fi
fi

# send the file and line to remote MacVim
"$mvim" --servername "$vimServer" --remote-silent \
    +"$line|exec 'norm zz'|silent!.foldopen!|" \
    +"norm zz" \
    "$file"
