#!/usr/bin/env bash
set -eu

PATH="$PATH":/usr/local/bin
log=~/.context-adapter.log

osascript ~/Library/Scripts/"Adapt to Current Displays".scpt &>"$log" &

ctx=$(tail -f "$log" | sed -n '/Detected context: / { s/.*: //p; q; }')
growlnotify -a Automator -n "Context Adapter" \
    -t "$ctx" -m "Adapting to Context.." 


wait
