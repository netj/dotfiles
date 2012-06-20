#!/usr/bin/osascript
# AppleScript for setting Gmail email addresses and Jabber IM fields
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-04-28
# See: http://www.macosxtips.co.uk/index_files/bulk-edit-address-book-contacts.html

tell application "Address Book"
	-- Google Talk IM field but no Gmail email
	repeat while true
		set peopleToChange to (people whose label of Jabber handles contains "Google Talk" and label of emails does not contain "Gmail")
		if number of items in peopleToChange = 0 then exit repeat
		set thisPerson to some item of peopleToChange
		repeat with theJabberIM in (Jabber handles of thisPerson whose label is "Google Talk")
			set gmailAddress to value of theJabberIM
			-- check if thisPerson already has the email address
			if (emails of thisPerson whose value is gmailAddress) = {} then
				log thisPerson's name & ": adding email " & gmailAddress & ""
				-- return gmailAddress
				make new email at end of emails of thisPerson with properties {label:"Gmail", value:gmailAddress}
			else
				log thisPerson's name & ": changing " & gmailAddress & "'s label to \"Gmail\""
				repeat with theEmail in (emails of thisPerson whose value = gmailAddress)
					-- return gmailAddress
					set label of theEmail to "Gmail"
				end repeat
			end if
			save
		end repeat
	end repeat
end tell
