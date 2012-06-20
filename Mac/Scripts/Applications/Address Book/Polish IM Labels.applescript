#!/usr/bin/osascript
# AppleScript for setting uniform label to IM fields
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-04-17
# See: http://www.macosxtips.co.uk/index_files/bulk-edit-address-book-contacts.html

tell application "Address Book"
	considering case
		repeat with i from 1 to 5
			-- facebook labels for some IM fields
			repeat while true
				set peopleToChange to (people whose value of Jabber handle i ends with "@chat.facebook.com" and label of Jabber handle i ≠ "Facebook")
				if number of items in peopleToChange = 0 then exit repeat
				set thisPerson to item 1 of peopleToChange
				set theJabberIM to Jabber handle i of thisPerson
				log thisPerson's name & " (" & theJabberIM's value & "):	" & theJabberIM's label & " -> Facebook"
				set label of theJabberIM to "Facebook"
				save
			end repeat
			
			-- Google Talk labels for some Jabber IM fields
			repeat while true
				set peopleToChange to (people whose value of Jabber handle i ends with "@gmail.com" and label of Jabber handle i ≠ "Google Talk")
				if number of items in peopleToChange = 0 then exit repeat
				set thisPerson to item 1 of peopleToChange
				set theJabberIM to Jabber handle i of thisPerson
				log thisPerson's name & " (" & theJabberIM's value & "):	" & theJabberIM's label & " -> Google Talk"
				set label of theJabberIM to "Google Talk"
				save
			end repeat
			
			-- MSN labels for MSN IM fields
			repeat while true
				set peopleToChange to (people whose value of MSN handle i ≠ missing value and label of MSN handle i ≠ "MSN")
				if number of items in peopleToChange = 0 then exit repeat
				set thisPerson to item 1 of peopleToChange
				set theMSNIM to MSN handle i of thisPerson
				log thisPerson's name & " (" & theMSNIM's value & "):	" & theMSNIM's label & " -> MSN"
				set label of theMSNIM to "MSN"
				save
			end repeat
		end repeat
	end considering
	
	
	(*
	repeat with p in (get selection)
		return count Jabber handle of p
	end repeat
*)
	(*
	
to match(a)
	return 0 < (count (a where it contains "1588"))
end match
	set p to some person that value of phone 1 starts with "1588"
	p's name
	return (value of phone of p)
	
	set facebookIMPeople to people where count (Jabber handles in it) > 0
	
	set i to 2
	set facebookIMPeople to people whose Jabber handle i's value contains "@chat.facebook.com"
	return count facebookIMPeople
	
	
	set peopleToChange to people whose (value of (every Jabber handle whose value contains "@chat.facebook.com")) is not ""
	repeat with p in peopleToChange
		--(every Jabber handle of it whose value contains "@chat.facebook.com") > 0)
		return name of p
	end repeat
	(*
	people whose length of (items of Jabber handle) > 0 -- (every Jabber handle whose value contains "@chat.facebook.com")) > 0
	label of Jabber handle of first item of peopleToChange as string
	repeat with thePerson in peopleToChange
		set (street of first address) of thePerson to "123 New Street"
	end repeat
	
	repeat with p in (get selection)
		return name of p
	end repeat
	*)
	-- save
	*)
end tell
