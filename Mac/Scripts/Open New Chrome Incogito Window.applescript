# AppleScript for opening a new Chrome Incogito window (for the current web page in Safari/Chrome)
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2014-07-04

#tell application "Google Chrome" to activate # XXX just for easier debugging

# First, detect and copy URL if a known web browser is the current application
set theURL to missing value
try
    tell application "System Events" to set currentAppName to name of first application process whose frontmost is true
    if currentAppName is "Safari" then
        tell application "Safari" to set theURL to URL of front document
    else if currentAppName is "Google Chrome" then
        tell application "Google Chrome"'s front window to set theURL to URL of tab (active tab index)
    end if
end try

# Find the app's icon from Dock
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
	# If not found, activate the app, then search for the icon again
	tell application appName to activate
	delay 1
	set appIcon to findAppIcon()
	if appIcon is missing value then
		display alert appName & " is not available"
		return 1
	end if
end if

# Then, click the Incogito item from its Dock menu
tell application "System Events"
	try
		perform action "AXShowMenu" of appIcon
		click menu item -9 of menu 1 of appIcon
	on error err
		display alert err
		return 2
	end try
end tell

# Finally, open the URL into the new window
if theURL is not missing value then
    delay 1
    tell application "Google Chrome"'s front window to set URL of tab (active tab index) to theURL
end if


# vim:ft=applescript:sw=4:sts=4:ts=4
