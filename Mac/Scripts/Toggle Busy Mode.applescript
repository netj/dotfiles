#!/usr/bin/osascript
# Toggle Busy Mode by switching on/off some apps:
#  e.g., Notification Center, Growl, Messages, and Caffeine
# 
# Author: Jaeho Shin <netj@cs.stanford.edu>
# Created: 2012-12-01

on run
	tell application "System Events"
		set UI elements enabled to yes
		key up {command, option, control, shift}
		try
			set isDedicated to false
			
			-- Toggle Notification Center since 10.8 Mountain Lion
			try
				tell process "NotificationCenter"
					key down option
					set m to menu bar 1's menu bar item 1
					click m
					set isDedicated to exists (m's attribute "AXValue"'s value)
				end tell
			end try
			key up option
			
			-- Messages (iChat) status
			try
				tell application "Messages"
					if isDedicated then
						set status to away
						set status message to "busy… ⌛🔕💭👥"
					else
						log in every service
						set status to available
					end if
				end tell
			end try
			
			
			-- Toggle Growl
			try
				tell application "Growl"
					if isDedicated then
						pause
					else
						resume
					end if
				end tell
			end try
			
			-- Toggle Caffeine
			try
				if not (exists (processes whose name is "Caffeine")) then
					if isDedicated then
						tell application "Caffeine" to activate
					else
						error "No need to activate Caffeine"
					end if
				end if
				tell process "Caffeine"
					set caffeineIcon to first menu bar item of menu bar 1
					key down command
					cliclick of me on caffeineIcon
					key up command
					set activateFor to caffeineIcon's menu 1's menu item "Activate for"
					cliclick of me on activateFor
					cliclick of me on activateFor's menu 1's menu item "2 hours"
					delay 0.01
					if not isDedicated then cliclick of me on caffeineIcon
				end tell
			end try
		end try
		key up {command, option, control, shift}
		isDedicated
	end tell
end run

-- http://www.bluem.net/en/mac/cliclick/
property pathToCLIClick : (system attribute "HOME") & "/bin/cliclick"
on cliclick on target
	tell application "System Events" to set {x, y} to position of target
	do shell script pathToCLIClick & " -r c:" & (x + 10) & "," & (y + 10)
	delay 1.0E-4
end cliclick

# vim:sw=4:sts=4:ts=4:noet:ft=applescript
