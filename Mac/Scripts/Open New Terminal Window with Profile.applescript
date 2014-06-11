# Open New Terminal Window with Profile XYZ
#  which could be useful to open a new Terminal at login time that has a
#  startup command defined in its profile.
# 
# See: http://apple.stackexchange.com/q/122875
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2014-03-02

on run args
	if (count items of args) > 0 then
		set {profileName} to args
	else
		set profileName to (get system attribute "TERM_PROFILE")
		if profileName is "" or profileName is missing value then
			set profileName to "Basic"
		end if
	end if
	tell application "Terminal"
		try
			set tmpSettings to settings set profileName
			set origSettings to default settings
			set default settings to tmpSettings
			activate
			tell application "System Events" to keystroke "n" using command down
			set default settings to origSettings
		end try
	end tell
end run
