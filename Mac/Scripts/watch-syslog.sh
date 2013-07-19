#!/usr/bin/env bash
# Watch /var/log/system.log and run commands whenever given pattern appears.
# Usage: watch-syslog [-b MSECS | -e MSECS] GREP_PATTERN PID_PATH COMMAND [ARG]...
# 
# When -b MSECS is given, 
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-11-17
set -eu

invokeAtBeginning=true
intervalMSEC=1000
while getopts "b:e:" o; do
    case $o in
        b)
            invokeAtBeginning=true
            intervalMSEC=$OPTARG
            ;;
        e)
            invokeAtBeginning=false
            intervalMSEC=$OPTARG
            ;;
    esac
done
shift $(( $OPTIND - 1 ))

[ $# -gt 2 ] || { sed -n '2,/^#$/s/^# //p' <"$0"; exit 1; }

greppatt=$1; shift
pidfile=$1; shift
timestamp=$pidfile.t

# check pidfile if already watching
if pid=$(cat "$pidfile" 2>/dev/null) && ps -o command= $pid 2>/dev/null |
        grep -F "$(basename "$0")" | grep -q -F "$(basename "$pidfile")"; then
    echo >&2 "$pidfile: Already running as PID $pid"
    exit 2
else
    echo $$ >"$pidfile"
fi

if $invokeAtBeginning; then
    throttle() {
        timestampWithinInterval || "$@" &
    }
else
    intervalS=$(bc <<<"scale=3; $intervalMSEC / 1000")
    lastpgid=
    throttle() {
        [ -z "$lastpgid" ] || kill -TERM -$lastpgid 2>/dev/null
        set -m
        {
            sleep $intervalS
            timestampWithinInterval || "$@" &
        } &
        lastpgid=$!
        set +m
    }
fi

timestampWithinInterval() {
    local ts; read ts <"$timestamp" 2>/dev/null || ts=0
    [[ $(( $(date +%s%N) - $ts )) -le ${intervalMSEC}000000 ]] || {
        date +%s%N >"$timestamp"
        false
    }
}

# monitor system log to find the given pattern
lasttime=
tail -qF /var/log/system.log |
grep --line-buffered "$greppatt" |
while read -r line; do
    # launch the command with the line in env
    WATCH_SYSLOG_LINE="$line" \
    throttle "$@" || true
done
