#!/usr/bin/osascript
# OpenThisPageWithChrome.scpt -- open the current page from Google Chrome
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-05-01

# Get the current URL from Safari.
tell application "Safari" to set theURL to URL of front document

# Find if there are existing Chrome windows in the current space.
# This can't be done by simply telling application "Google Chrome" to check exists windows.
tell application "System Events"
	try
		tell application process "Google Chrome"
			set titles to get title of windows whose value of attribute "AXMinimized" is not true
		end tell
	on error
		set titles to {}
	end try
end tell
set windowAlreadyExistsInCurrentSpace to (count titles) > 0

# Open the URL in a new Chrome tab of either a new or existing window.
tell application "Google Chrome"
	activate
	if windowAlreadyExistsInCurrentSpace then
		make new tab at end of tabs of front window with properties {URL:theURL}
	else
		set w to make new window
		set t to first tab of w
		set t's URL to theURL
	end if
end tell
