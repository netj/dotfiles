#!/bin/sh
# A watch-syslog app to take pictures whenever a login attempt is made through the screen saver.
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-04-18
: ${MinSecsBetweenShots:=1}
export MinSecsBetweenShots

PATH=~/Library/Scripts:"$PATH"
exec watch-syslog.sh \
    'loginwindow\[[0-9]\+\]: in pam_sm_authenticate(): Got user:' \
    ~/.monitorLoginAttempts.pid  bash -c '
TakeOneLoginShot.sh attempt &
'
