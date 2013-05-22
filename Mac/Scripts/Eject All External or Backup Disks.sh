#!/usr/bin/env bash
# A script to unmount/eject all external/backup volumes and disks
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-05-21
set -eu

# See-Also: http://atastypixel.com/blog/automatically-eject-all-disks-on-sleep-reconnect-on-wake/
ejectDisk() {
    local diskname=$1
    diskutil eject "$diskname" || (
        diskname=${diskname#/@(dev|Volumes)/}
        osascript -e 'tell application "Finder" to eject disk "'"$diskname"'"'
    )
    # TODO force unmountDisk if still there
    #diskutil unmountDisk force $diskname
}
ejectDisks() {
    while read diskname; do
        ejectDisk $diskname &
    done
}

# unmount all USB disks
system_profiler SPUSBDataType | grep 'BSD Name: disk\d+$' | sed 's/.*: //' | ejectDisks

# eject all remote time machine destinations first (sparsebundle)
tmutil destinationinfo | grep "Mount Point" | sed 's/.*: //' |
while read tmdest; do
    remotedisk=$(hdiutil info |
        sed -n '\#^image-path *: '"$tmdest"'#,/^==*$/{
            \#/Volumes/.*$#{ s#.*\(/Volumes/.*\)$#\1#p; q; }
        }')
    [ -n "$remotedisk" ] || continue
    ejectDisk "$remotedisk" &
done

# eject all remaining time machine destinations
tmutil destinationinfo | grep "Mount Point" | sed 's/.*: //' | ejectDisks
