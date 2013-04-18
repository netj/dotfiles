#!/bin/sh
# A watch-syslog app to take pictures after a successful login.
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-04-18
PATH=~/Library/Scripts:$PATH \
exec watch-syslog.sh \
    'loginwindow\[[0-9]\+\]: in pam_sm_setcred(): Establishing credentials' \
    ~/.loginshots.pid  bash -c '
sleep $(cat ~/.loginshots.delay 2>/dev/null || echo 0)
TakeOneLoginShot.sh  &
'
