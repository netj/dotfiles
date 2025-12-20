# AppleScript for resizing windows vertically
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-07-17

# We just need a sufficiently large number for the new height
set maxHeight to 10000

# Figure out the frontmost/current process name
# http://ctrloptcmd.com/archives/536/center-and-resize-window-with-applescript/
tell application "System Events" to set theProcessName to the name of first item of (every process whose frontmost is true)

# First, try with window's bounds in Standard Suite
try
	try
		# ask the current application for the first window
		set theWindow to get first window
	on error
		# or the frontmost window explicitly to the detected frontmost application
		# XXX e.g., Terminal with Visor requires a workaround for getting frontmost window
		set theWindow to missing value
		tell application theProcessName
			repeat with w in (get windows)
				try
					if w's frontmost then
						set theWindow to w
						exit repeat
					end if
				end try
			end repeat
		end tell
		if theWindow is missing value then
			# or simply the first window of it
			tell application theProcessName to set theWindow to get first window
		end if
	end try
	
	# get the bounds of the window
	set {x1, y1, x2, y2} to theWindow's bounds
	
	# and check if it's already maximized or not
	set previousSizeFile to "$TMPDIR/MaximizeWindowsVertically/" & (theWindow's id)
	set previousSize to do shell script "cat " & previousSizeFile & " || true"
	if previousSize is "" then
		log "maximizing vertically: window " & theWindow's id
		# record current vertical position of this window
		do shell script "f=" & previousSizeFile & " && " & ¬
			"mkdir -p ${f%/*} && " & ¬
			"echo >$f " & y1 & " " & y2
		# then maximize its height
		if y1 < 0 then
			set {y1, y2} to {-maxHeight, 0}
		else
			set {y1, y2} to {0, maxHeight}
		end if
		set theWindow's bounds to {x1, y1, x2, y2}
	else
		# restore the previous vertical position
		set {y1, y2} to words of previousSize
		log "restoring vertical position to " & previousSize & ": window " & theWindow's id
		do shell script "rm -f " & previousSizeFile
		set theWindow's bounds to {x1, y1, x2, y2}
	end if
	return
on error e
	set errmsg to "falling back to System Events UI scripting for '" & theProcessName & "' due to: " & e
	log errmsg
	#DEBUG #display alert errmsg

	# XXX bounds do not work in some apps if ran from FastScripts :( e.g. Safari
	# Then, try with window's position and size from System Events
	# See: http://ctrloptcmd.com/archives/536/center-and-resize-window-with-applescript/
	tell application "System Events"
		tell process theProcessName
			set theWindow to get first window
			# TODO find a good identifier for theWindow
			# TODO record and restore vertical position
			set {w, h} to theWindow's size
			set {x, y} to theWindow's position
			if y < 0 then
				set y to -maxHeight
			else
				set y to 0
			end if
			set theWindow's position to {x, y}
			set theWindow's size to {w, maxHeight}
		end tell
	end tell
end try

# See also:
# http://www.ithug.com/2007/09/applescript-moving-and-resizing-windows/
# http://macmembrane.com/resize-any-window-quickly-and-exactly-with-applescript-and-fastscripts/
# http://hints.macworld.com/article.php?story=20080523040419784

# vim:ts=4:sts=4:sw=4:noet
