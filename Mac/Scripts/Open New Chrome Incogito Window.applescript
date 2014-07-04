# AppleScript for opening a new Chrome Incogito window
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2014-07-04

# TODO detect and copy URL if Safari or Chrome is the current application

# find the app's icon from Dock
set appName to "Google Chrome"
property appNamesOnDock : {"Chrome"}
to findAppIcon()
	set appIcon to missing value
	# See: http://www.mac-forums.com/forums/os-x-operating-system/146570-applescript-detect-if-dock-contextual-menu-item-checked.html
	tell application "Dock" to activate
	tell application "System Events"
		set process "Dock"'s frontmost to true
		tell process "Dock" to activate
		repeat with n in appNamesOnDock
			try
				set appIcon to UI element n of list 1 of process "Dock"
				exit repeat
			end try
		end repeat
	end tell
	return appIcon
end findAppIcon
set appIcon to findAppIcon()
if appIcon is missing value then
	# if not found, activate the app, then search for the icon again
	tell application appName to activate
	delay 1
	set appIcon to findAppIcon()
	if appIcon is missing value then
		display alert appName & " is not available"
		return 1
	end if
end if

# finally, click the item from its Dock menu
tell application "System Events"
	try
		perform action "AXShowMenu" of appIcon
		click menu item -9 of menu 1 of appIcon
		return
	on error err
		display alert err
		return 2
	end try
end tell

# TODO paste URL into the new window
