on run args
	if (count items of args) > 0 then
		set {profileName} to args
	else
		set profileName to "Basic"
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