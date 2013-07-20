#!/usr/bin/env osascript
# Toggle Window on All Spaces (with Afloat)
# See: http://infinite-labs.net/afloat/
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-07-20

tell application "System Events"
	try
		set currentAppProc to (first process whose frontmost is true)
		tell currentAppProc
			set windowMenu to menu 1 of (first menu bar item whose title is "Window" or title is "윈도우") of menu bar 1
			click menu item "Adjust Effects" of windowMenu
			tell window "Afloat — Adjust Effects"
				set chkbox to checkbox "Keep this window on the screen on all Spaces"
				click chkbox
				click button "Done"
			end tell
		end tell
	end try
end tell
