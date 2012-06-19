# AppleScript for creating a new Memo in Mail
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2010-08-18
# See: http://www.macosxhints.com/article.php?story=20080707160311715

tell application "System Events"
	tell application "Mail" to activate
	keystroke "n" using {command down, control down}
end tell
