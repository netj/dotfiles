# AppleScript for resizing windows vertically
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-07-17

# We just need a sufficiently large number for the new height
set maxHeight to 10000

# Figure out the size of the display
# See: http://daringfireball.net/2006/12/display_size_applescript_the_lazy_way
-- # http://stackoverflow.com/questions/1866912/applescript-how-to-get-current-display-resolution
-- set screenWidth to (do shell script "system_profiler SPDisplaysDataType | awk '/Resolution/{print $2}'")
-- tell application "Finder"
-- 	set screenSize to bounds of window of desktop
-- 	set h1 to item 2 of screenSize
-- 	set h2 to item 4 of screenSize
-- 	if h1 < h2 then
-- 		set heightBegins to h1
-- 	else
-- 		set heightBegins to h2
-- 	end if
-- 	if h1 > h2 then
-- 		set heightEnds to h1
-- 	else
-- 		set heightEnds to h2
-- 	end if
--         if heightBegins < 0 and -heightBegins > heightEnds then
--                 set maxHeight to -heightBegins
--         else
--                 set maxHeight to heightEnds
--         end if
-- end tell

# Figure out the frontmost/current process name
# http://ctrloptcmd.com/archives/536/center-and-resize-window-with-applescript/
tell application "System Events" to ￢
	set theProcessName to the name of first item of ￢
		(every process whose frontmost is true)

# First, try with window's bounds
try
	# XXX Terminal with Visor requires a workaround for getting frontmost window
	if theProcessName is "Terminal" then
		tell application "Terminal"
			repeat with w in (get windows)
				try
					if w's frontmost then
						set theWindow to w
						exit repeat
					end if
				end try
			end repeat
		end tell
	else
		set theWindow to get first window
	end if
	set {x1, y1, x2, y2} to theWindow's bounds
	--display dialog (x1 &","& y1 &" -- "& x2 &","& y2 & "    ;" & maxHeight) as text
	if y1 < 0 then
		set {y1, y2} to {-maxHeight, 0}
	else
		set {y1, y2} to {0, maxHeight}
	end if
	--display dialog (x1 &","& y1 & " -- " &  x2 &","& y2) as text
	set theWindow's bounds to {x1, y1, x2, y2}
	return
on error e
	--display dialog "Error " & e
end try

# XXX bounds do not work in some apps if ran from FastScripts :( e.g. Safari
# So try with window's position and size from System Events
# See: http://ctrloptcmd.com/archives/536/center-and-resize-window-with-applescript/
tell application "System Events"
	tell process theProcessName
		set theWindow to get first window
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


# See also:
# http://www.ithug.com/2007/09/applescript-moving-and-resizing-windows/
# http://macmembrane.com/resize-any-window-quickly-and-exactly-with-applescript-and-fastscripts/
# http://hints.macworld.com/article.php?story=20080523040419784
