# AppleScript for creating a new Stickies memo
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2010-08-18
# See: http://www.mail-archive.com/blacktree-quicksilver@googlegroups.com/msg03864.html
# See: http://www.macosxhints.com/article.php?story=20080707160311715

-- TODO use services not to switch Spaces

tell application "System Events"
	tell application "Stickies" to activate
	keystroke "n" using {command down}
end tell
