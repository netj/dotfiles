# AppleScript for creating a new Message in Mail
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-03-04

tell application "System Events"
	tell application "Mail" to activate
	keystroke "n" using {command down}
end tell
