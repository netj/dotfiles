#!/bin/sh
# A watch-syslog app to take pictures whenever a login attempt is made through the screen saver.
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-04-18
PATH=~/Library/Scripts:$PATH \
exec watch-syslog.sh \
    'WindowServer\[[0-9]\+\]: MPAccessSurfaceForDisplayDevice\|loginwindow\[[0-9]\+\]: in pam_sm_authenticate(): Got user:' \
    ~/.monitorLoginAttempts.pid  bash -c '
MinSecsBetweenShots=1 TakeOneLoginShot.sh &
'
