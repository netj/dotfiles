#!/usr/bin/env bash
set -eu
name=${0%.sh}
log=~/.${name##*/}.log
! [ -t 1 ] || tail -qF --pid=$$ $log &
exec osascript "$name.scpt" &>>$log
