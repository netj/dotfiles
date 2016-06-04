set FileExt to ".vcf"

tell application "Finder"
	set backupDir to choose folder
	set backupDirPath to POSIX path of (backupDir as alias)
end tell

tell application "Contacts"
	activate
	repeat with g in groups
		set groupName to g's name
		set fileName to backupDirPath & "/" & groupName & FileExt
		set qFileName to quoted form of fileName
		-- display notification "Backup " & fileName
		do shell script ": >" & qFileName
		set backupTotal to count people in g
		set backupSoFar to 0
		repeat with p in (get people in g)
			set backupSoFar to backupSoFar + 1
			display notification "Backup [" & backupSoFar & "/" & backupTotal & "] " & fileName
			# See: https://discussions.apple.com/thread/2745012?start=0&tstart=0
			set the clipboard to p's vcard as text
			do shell script "LC_CTYPE=UTF-8 pbpaste >>" & qFileName
		end repeat
	end repeat
end tell

display notification "Finished backup"