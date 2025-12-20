#!/usr/bin/osascript
# AppleScript for synchronizing Facebook profile page URLs and Facebook Chat IM fields
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-04-28
# See: http://www.macosxtips.co.uk/index_files/bulk-edit-address-book-contacts.html

property MaxNumberOfJabberHandles : 5

on accessFacebookGraph(fbId, field)
	-- TODO parse JSON
	set value to do shell script "curl -s -A 'MacAddressBookScripts/1.0 AppleWebKit/534.51.22' " & " https://graph.facebook.com/" & fbId & " | grep '\"" & field & "\":' | sed 's#^.*: *\"\\(.*\\)\".*$#\\1#g'"
	return value
end accessFacebookGraph


tell application "Address Book"
	-- Clean old facebook
	considering case
		set peopleToClean to (people whose label of urls contains "facebook")
		repeat with p in peopleToClean
			set fbURLs to get (p's urls whose label is "facebook") -- and value starts with "http://")
			log "cleaning " & (get name of p) & ": " & number of fbURLs & " facebook URLs"
			if number of fbURLs = 1 then
				set u to first item of fbURLs
				log ("  relabeling " & label of u & ": " & value of u)
				set u's label to "Facebook"
			else
				repeat with u in fbURLs
					if label of u = "facebook" then
						log ("  deleting " & label of u & ": " & value of u)
						delete u
					end if
				end repeat
			end if
		end repeat
	end considering
	
	-- Derive Profile URL from Facebook IM fields
	repeat with i from 1 to MaxNumberOfJabberHandles
		repeat while true
			set peopleToChange to (people whose value of Jabber handle i ends with "@chat.facebook.com" and label of urls does not contain "Facebook")
			if number of items in peopleToChange = 0 then exit repeat
			set thisPerson to item 1 of peopleToChange
			set theJabberIM to Jabber handle i of thisPerson
			set facebookChatId to value of theJabberIM
			set profileId to text 2 thru end of facebookChatId
			set AppleScript's text item delimiters to "@"
			set profileId to first text item of profileId
			set AppleScript's text item delimiters to ""
			-- try to get link from Facebook Social Graph
			set profileURL to ""
			set profileURL to my accessFacebookGraph(profileId, "link")
			if profileURL is "" then set profileURL to "https://www.facebook.com/profile.php?id=" & profileId
			log thisPerson's name & ": " & profileURL & ""
			make new url at end of urls of thisPerson with properties {label:"Facebook", value:profileURL}
			save
		end repeat
	end repeat
	
	-- Derive IM field from Facebook Profile URL
	set peopleToChange to (people whose label of urls contains "Facebook")
	repeat with thisPerson in peopleToChange
		if label of thisPerson's Jabber handles does not contain "Facebook" then
			set fbProfileURL to value of (thisPerson's urls whose label is "Facebook")
			set fbId to do shell script "u='" & fbProfileURL & "'; " & "case $u in " & "  *\\?id=*)         u=${u##*?id=} ;; " & "  *.facebook.com/*) u=${u##*/}    ;; " & "esac; echo \"$u\""
			if "" = (do shell script "i='" & fbId & "'; echo -n \"${i//[0-9]/}\"") then
				-- if fbId is already all digits, it must be the id we're looking for
				set profileId to fbId
			else
				-- or ask Facebook
				set profileId to my accessFacebookGraph(fbId, "id")
				if profileId = "" then profileId = fbId
			end if
			set facebookChatId to "-" & profileId & "@chat.facebook.com"
			log thisPerson's name & ": " & facebookChatId
			make new Jabber handle at end of Jabber handles of thisPerson with properties {label:"Facebook", value:facebookChatId}
			save
		else
			-- make sure label is capitalized (Facebook)
			considering case
				repeat with j in (thisPerson's Jabber handles whose label is "facebook")
					if j's label ≠ "Facebook" then
						log "Fixing label to Facebook: " & thisPerson's name & ": " & (get j's label)
						set j's label to "Facebook"
						save
					end if
				end repeat
			end considering
		end if
	end repeat
end tell
