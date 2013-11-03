#!/bin/sh
# A watch-syslog app to take pictures whenever a login attempt is made through the screen saver.
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-04-18
: ${MinSecsBetweenShots:=1}
export MinSecsBetweenShots

PATH=~/Library/Scripts:"$PATH"
exec watch-syslog.sh \
    -w "watch-notes com.apple.screenLockUIIsShown" \
    '.' \
    ~/.monitorLoginAttempts.pid  bash -c '
TakeOneLoginShot.sh attempt &
'
