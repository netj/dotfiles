#!/bin/sh
# A watch-syslog app to take pictures after a successful login.
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-04-18
PATH=~/Library/Scripts:$PATH \
exec watch-syslog.sh -e 10000 \
    'loginwindow\[[0-9]\+\]: ' \
    ~/.loginshots.pid  bash -c '
sleep $(cat ~/.loginshots.delay 2>/dev/null || echo 0)
TakeOneLoginShot.sh  &
'
