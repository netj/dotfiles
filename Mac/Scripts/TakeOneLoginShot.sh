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

: \
    ${DateFormat:=%Y/%m/%d-%H%M%S} \
    ${MinSecsBetweenShots:=20} \
    ${NumRetries:=3} \
    ${JPEGQuality:=20} \
    #

[ -d ~/.loginshots ] || ln -sfn ~/Dropbox/Photos/LoginShots ~/.loginshots
LoginShotsFolder=~/.loginshots

event=${*:-}

filename="$LoginShotsFolder/$(date +"$DateFormat")$event.jpg"
mkdir -p "$(dirname "$filename")"

latest="$LoginShotsFolder"/LATEST.JPG

# try not to take too many shots in a short period
timediff=$(( $(date +%s) - $(date -r "$latest" +%s 2>/dev/null || echo 0) ))
if [[ $timediff -lt $MinSecsBetweenShots ]]; then
    echo >&2 "throttling shots: only ${timediff}s have past"
    exit 2
fi

# take a shot
delay=4
for i in $(seq $NumRetries); do
    imagesnap "$filename" & pid=$!
    sleep $delay
    if [ -s "$filename" ]; then
        break
    elif ps -o pid= -p $pid &>/dev/null; then
        kill $pid
    fi
    let delay+=2
done
if ! [ -s "$filename" ]; then
    echo >&2 "imagesnap failed ($NumRetries tries) for $filename"
    exit 4
fi

# and compress
sips -s format jpeg -s formatOptions $JPEGQuality "$filename"

# update the latest pointer
ln -sfn "${filename#$LoginShotsFolder/}" "$latest"
