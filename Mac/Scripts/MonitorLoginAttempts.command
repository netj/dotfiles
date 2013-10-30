#!/bin/sh
# A watch-syslog app to take pictures whenever a login attempt is made through the screen saver.
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-04-18
: ${MinSecsBetweenShots:=1}
export MinSecsBetweenShots

PATH=~/Library/Scripts:"$PATH"
exec watch-syslog.sh -b 5000 \
    'loginwindow\[[0-9]\+\]: ' \
    ~/.monitorLoginAttempts.pid  bash -c '
TakeOneLoginShot.sh attempt &
'
