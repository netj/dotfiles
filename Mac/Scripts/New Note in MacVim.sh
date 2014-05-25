#!/usr/bin/env bash
set -eu
shopt -s extglob

PATH+=:/opt/homebrew/bin
title=$(basename "$0" .sh)
iconPath=/Applications/MacVim.app/Contents/Resources/MacVim.icns

if name=$(
    osascript -e "get text returned of (\
        display dialog \"Create a new note named:\" \
            with title \"$title\" \
            $(! [ -e "$iconPath" ] || echo "with icon POSIX file \"$iconPath\"") \
            default answer \"$(date +%m%d) \" \
        )"
); then
    name=${name##+([[:space:]])}
    name=${name%%+([[:space:]])}
    exec mvim ~/Notes/"$name".md +"cd %:h"
fi
