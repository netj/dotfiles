-- AppleScript for listening to the pronunciation of the selected words in Dictionary
-- Author: Jaeho Shin <netj@sparcs.org>
-- Created: 2009-10-12

try
	set previousContent to the clipboard
on error
	set previousContent to ""
end try
set the clipboard to ""

tell application "Dictionary"
	activate
	if frontmost then
		delay 0.5 -- behaves strangely when invoked from FastScripts
	else
		repeat until frontmost
			delay 0.1
		end repeat
	end if
	tell application "System Events"
		keystroke "c" using command down
		delay 0.5
	end tell
	say (the clipboard) with stopping current speech without waiting until completion
end tell

set the clipboard to previousContent
