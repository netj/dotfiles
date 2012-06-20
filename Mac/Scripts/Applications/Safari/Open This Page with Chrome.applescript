#!/usr/bin/osascript
# OpenThisPageWithChrome.scpt -- open the current page from Google Chrome
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-05-01

tell application "Safari"
	set theURL to URL of front document
	tell application "Google Chrome"
		activate
		if exists windows then
			make new tab at end of tabs of front window with properties {URL:theURL}
		else
			set w to make new window
			set t to first tab of w
			set t's URL to theURL
		end if
	end tell
end tell
