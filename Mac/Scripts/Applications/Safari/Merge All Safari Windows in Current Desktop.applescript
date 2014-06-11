# Merge All Safari Windows in Current Desktop.applescript
# 
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2014-06-11

# find which windows are not minimized and visible on the current space
tell application "System Events"
	tell application process "Safari"
		set titles to get title of windows whose value of attribute "AXMinimized" is not true
	end tell
end tell

if (count titles) < 2 then
	log "No Safari windows to merge :)"
	return
end if

# then move tabs from those windows to the front window
tell application "Safari"
	set windowToMerge to front window
	log "Merging visible Safari windows to: window id " & windowToMerge's id & " (" & windowToMerge's name & " )"
	repeat with w in (get windows whose id is not windowToMerge's id)
		if titles contains w's name then
			log "Merging " & (count w's tabs) & " tabs from window id " & w's id & " (" & w's name & ")"
			move w's tabs to end of windowToMerge's tabs
		end if
	end repeat
end tell
