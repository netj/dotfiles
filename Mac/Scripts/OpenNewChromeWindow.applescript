# AppleScript for opening a new Chrome window
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2010-02-06

# First, try the control-click menu of Chrome app icon on the Dock
# See: http://www.mac-forums.com/forums/os-x-operating-system/146570-applescript-detect-if-dock-contextual-menu-item-checked.html
property appNames : {"Chrome"}
tell application "Dock" to activate
tell application "System Events"
	tell process "Dock"
		set frontmost to true
		activate
		tell list 1
			repeat with n in appNames
				try
					set appIcon to UI element n
					exit repeat
				end try
			end repeat
			try
				perform action "AXShowMenu" of appIcon
				click menu item -9 of menu 1 of appIcon -- secret window, -10 = window
				(*
				delay 0.1
				repeat 6 times -- count number of items to the one you want
					key code 126 -- up arrow
					-- key code 125 -- down arrow
				end repeat
				repeat 2 times
					key code 36 -- return key
				end repeat
				*)
				return
			end try
		end tell
	end tell
end tell

# XXX old style

-- tell application "Finder" to open location "http://google.com" --"chrome://newtab"

tell application "Google Chrome"
	--make new document at front
	activate
end tell

-- XXX Chrome will eventually support Scripting
tell application "System Events"
	tell process "Google Chrome"
		click menu item "새 창" of menu "파일" of menu bar 1
	end tell
end tell
