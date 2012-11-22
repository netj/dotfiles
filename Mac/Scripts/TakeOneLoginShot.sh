#!/usr/bin/env bash
# Takes a photo with Mac's built-in camera silently under ~/.loginshots/
# 
# Requires imagesnap, which can be installed with Homebrew one-liner:
# 
#    brew install imagesnap
# 
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-11-17
set -eu

: ${DateFormat:=%Y/%m/%d-%H%M%S} ${NumRetries:=3} ${JPEGQuality:=20}

[ -d ~/.loginshots ] || ln -sfn ~/Dropbox/Photos/LoginShots ~/.loginshots
LoginShotsFolder=~/.loginshots

event=${*:-}

filename="$LoginShotsFolder/$(date +"$DateFormat")$event.jpg"
mkdir -p "$(dirname "$filename")"

# take a shot
for i in $(seq $NumRetries); do
    imagesnap "$filename" & pid=$!
    sleep 3
    if [ -s "$filename" ]; then
        break
    elif ps -o pid= -p $pid &>/dev/null; then
        kill $pid
    fi
done
[ -s "$filename" ] || echo >&2 "imagesnap failed ($NumRetries tries) for $filename"

# and compress
sips -s format jpeg -s formatOptions $JPEGQuality "$filename"
