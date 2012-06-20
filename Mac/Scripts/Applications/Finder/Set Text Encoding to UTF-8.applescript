#!/usr/bin/osascript
# AppleScript for setting text encoding to UTF-8
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-03-25
# See-Also: http://vim.1045645.n5.nabble.com/MacVim-file-encoding-and-Quicklook-td1216113.html
# See-Also: http://xahlee.org/comp/OS_X_extended_attributes_xattr.html

tell application "Finder"
	set names to ""
	repeat with f in (selection as alias list)
		set names to names & " " & (quoted form of (POSIX path of (f as alias)))
	end repeat
	if names is not equal to "" then
		# TODO maybe one might want to pick an encoding?
		# choose from list { "UTF-8", "Korean" }
		do shell script "xattr -w com.apple.TextEncoding 'UTF-8;134217984'" & names
	end if
end tell
