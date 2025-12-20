set FileExt to ".vcf"

tell application "Finder"
	set backupDir to choose folder
	repeat with f in (get files in backupDir)
		set f to f as alias
		if f's name ends with FileExt then
			set groupName to (get f's name)'s text 1 thru -((FileExt's length) + 1)
			set vcfPath to f's POSIX path
			tell application "Contacts"
				activate
				display notification "Importing " & vcfPath
				try
					set g to (first group whose name is groupName)
				on error
					set g to make new group with properties {name:groupName}
					save g
				end try
				set g's selected to true
				do shell script "open " & (quoted form of vcfPath)
				delay 1
				tell application "System Events" to key code 36 -- return key
			end tell
		end if
	end repeat
end tell

display notification "Finished importing"