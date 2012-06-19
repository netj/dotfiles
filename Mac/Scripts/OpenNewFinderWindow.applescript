# AppleScript for opening a new Finder window
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-10-21

# First, try the control-click menu of Terminal app icon on the Dock
# See: http://www.mac-forums.com/forums/os-x-operating-system/146570-applescript-detect-if-dock-contextual-menu-item-checked.html
property appNames : {"Finder"}
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
				return
			end try
		end tell
	end tell
end tell

# old style -- does not preserve the current Space, i.e. switches to the Space where the active app window exists
tell application "Finder" to activate
tell application "System Events"
	tell process "Finder"
		click menu item 1 of menu 3 of menu bar 1
		-- click menu item "새로운 Finder 윈도우" of menu "파일" of menu bar 1
	end tell
end tell
