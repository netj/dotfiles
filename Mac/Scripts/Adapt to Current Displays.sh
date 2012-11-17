#!/usr/bin/env bash
set -eu

PATH="$PATH":/usr/local/bin
#set -x
#exec >>/tmp/ctx.log 2>&1

: ${ctx:=$(osascript -e 'tell application "ControlPlane" to get current context')}
growlnotify -a ControlPlane -n "ControlPlane growlnotify" \
    -t "$ctx" -m "Adapting to Context.." 

osascript ~/Library/Scripts/"Adapt to Current Displays".scpt
