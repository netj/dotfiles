#!/usr/bin/env bash
# Watch /var/log/system.log and run commands whenever given pattern appears.
# Usage: watch-syslog [-OPTIONS] GREP_PATTERN PID_PATH COMMAND [ARG]...
# 
# Available OPTIONS are: [-f] [-b MSECS | -e MSECS] [-w WATCH_COMMAND]
# 
# When -b MSECS is given, trigger of COMMAND is throttled and it is executed
# once every MSECS at the beginning when lines matching GREP_PATTERN are
# observed.  On the otherhand, -e MSECS throttles COMMAND triggering similarly,
# but once every MSECS at the end.
# 
# WATCH_COMMAND defaults to 'tail -f /var/log/system.log', but can be replaced to
# any command that starts a long-running blocking process producing lines to
# standard output.
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-11-17
set -eu

invokeAtBeginning=true
intervalMSEC=1000
forceStart=false
watchCommand='tail -F /var/log/system.log'
while getopts "fb:e:w:" o; do
    case $o in
        f)
            forceStart=true
            ;;
        b)
            invokeAtBeginning=true
            intervalMSEC=$OPTARG
            ;;
        e)
            invokeAtBeginning=false
            intervalMSEC=$OPTARG
            ;;
        w)
            watchCommand=$OPTARG
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
    if $forceStart; then
        kill -TERM -$(ps -o pgid= $pid)
    else
        echo >&2 "$pidfile: Already running as PID $pid"
        exit 2
    fi
fi
# record pid
echo $$ >"$pidfile"


# decide how we throttle the invocation of given command
if $invokeAtBeginning; then
    throttle() {
        timestampWithinInterval || "$@" &
        sleep 0.1
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
    now_usec() {
        perl -Mstrict -e '
            use Time::HiRes qw( gettimeofday );
            my ($secs, $usecs) = gettimeofday;
            print $secs, $usecs, "\n";
        '
    }
    [[ $(( $(now_usec) - $ts )) -le ${intervalMSEC}000 ]] || {
        now_usec >"$timestamp"
        false
    }
}

# monitor system log to find the given pattern
eval "$watchCommand" |
grep --line-buffered "$greppatt" |
while read -r line; do
    # launch the command with the line in env
    WATCH_SYSLOG_LINE="$line" \
    throttle "$@" || true
done
