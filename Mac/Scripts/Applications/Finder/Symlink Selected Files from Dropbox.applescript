#!/usr/bin/env osascript
# A script for quickly sharing selected files in Finder via Dropbox (with FastScripts)
# Author: Jaeho Shin <netj@cs.stanford.edu>
# Created: 2015-08-21

## find which files are selected in Finder
# XXX single file selection
#tell application "Finder" to get posix path of (the selection as alias)

# Supporting multiple selections requires a bit more code
# See: http://macscripter.net/viewtopic.php?id=33101
set selectedFilePaths to {}
tell application "Finder"
	if selection ≠ "" then
		set filelist to (selection)
		repeat with anElm in filelist
			set selectedFilePaths to selectedFilePaths & POSIX path of (anElm as alias)
		end repeat
		#set AppleScript'\''s text item delimiters to linefeed
		#posixList as Unicode text
	end if
end tell

# create symlinks from Dropbox folder, then reveal the symlink in Finder
repeat with f in selectedFilePaths
	do shell script "
		f=" & (quoted form of f) & " &&
		DropboxFolder=~/Dropbox/$(date +%Y) &&
		mkdir -p \"$DropboxFolder\" &&
		ln -sfnv \"$f\" \"$DropboxFolder\"/ &&
		open -R \"$DropboxFolder\"/\"$(basename \"$f\")\"
		"
end repeat
