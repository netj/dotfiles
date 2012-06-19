# AppleScript for opening a new Terminal window
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-10-02

# First, try the control-click menu of Terminal app icon on the Dock
# See: http://www.mac-forums.com/forums/os-x-operating-system/146570-applescript-detect-if-dock-contextual-menu-item-checked.html
property appNames : {"Terminal", "터미널"}
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
				click menu item -12 of menu 1 of appIcon
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

# old style -- does not preserve the current Space, i.e. switches to the Space where the active Terminal window exists
tell application "Terminal" to activate
tell application "System Events"
	tell process "Terminal"
		click menu item 1 of menu 3 of menu bar 1
		-- click menu item "새로운 윈도우" of menu "셸" of menu bar 1
	end tell
end tell
