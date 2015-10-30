# AppleScript to refresh/renew Kerberos Tickets
tell application "Ticket Viewer" to activate
tell application "System Events"
	set rs to process "Ticket Viewer"'s window 1's scroll area 1's table 1's rows's UI elements
	repeat with r in rs
		set btn to r's item 1's button 2
		if btn's attribute "AXDescription"'s value = "refresh" then
			click btn
		end if
	end repeat
end tell
-- TODO set as default
delay 4  # wait until tickets are refreshed
tell application "Ticket Viewer" to quit
