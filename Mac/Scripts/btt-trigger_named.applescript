#!/usr/bin/env osascript
# calling BetterTouchTool Named Triggers via StreamDeck / Mac Automation plugin using this .applescript is much easier/simpler
# than fumbling with BTT's StreamDeck plugin, defining a button with an id, then associating an action again inside BTT, etc.
on run argv
tell application "BetterTouchTool"
    repeat with arg in argv
        # display dialog arg
        trigger_named arg
    end repeat
end tell
return
end run
