#!/usr/bin/env bash
# Watch /var/log/system.log and run commands whenever given pattern appears.
# Usage: watch-syslog GREP_PATTERN PID_PATH COMMAND [ARG]...
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-11-17
set -eu

[ $# -gt 2 ] || { sed -n '2,/^#$/s/^# //p' <"$0"; exit 1; }

greppatt=$1; shift
pidfile=$1; shift

# check pidfile if already watching
if pid=$(cat "$pidfile" 2>/dev/null) && ps -o command= $pid 2>/dev/null |
        grep -F "$(basename "$0")" | grep -q -F "$(basename "$pidfile")"; then
    echo >&2 "$pidfile: Already running as PID $pid"
    exit 2
else
    echo $$ >"$pidfile"
fi

# monitor system log to find loginwindow activity
lasttime=
tail -qF /var/log/system.log |
grep --line-buffered "$greppatt" |
while read -r line; do
    t=${line%%]*}
    # skip consecutive log lines
    [[ $t != $lasttime ]] || continue
    # launch the command with line in env
    WATCH_SYSLOG_LINE="$line" \
    "$@" || true
    lasttime=$t
done
