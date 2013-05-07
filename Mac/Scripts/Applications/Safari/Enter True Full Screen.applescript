# An applescript to make Safari enter true full screen (automatically without toolbar)
# Usage: override Control-Command-F for Safari (with FastScript or alike apps)
# 
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-05-07
# See: https://discussions.apple.com/message/17068114#17068114

# Start or focus Safari
tell application "Safari" to activate

tell application "System Events"
	tell application process "Safari"
		# Enter Fullscreen first
		tell window 1
			click (every button whose description contains "full screen" or description contains "전체 화면")
		end tell
		
		# Wait for animation
		delay 2
		
		# Then, use the toolbar menu to "Hide toolbar"
		try
			perform action "AXShowMenu" of tool bar 1 of group 2 of window 1
			key code 125 # cursor down
			keystroke return
		end try
		
	end tell
end tell
