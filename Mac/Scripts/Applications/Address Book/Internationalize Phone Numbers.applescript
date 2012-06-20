#!/usr/bin/osascript
# AppleScript for internationalizing phone numbers
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2011-04-18

property defaultCountryCodes : {"+82", "+1"}
property decimalDigits : "0123456789"

tell application "Address Book"
	
	set countryCodeToUse to choose from list defaultCountryCodes with title "Internationalize Phone Numbers" with prompt "Choose the Country Code you want to put to the phone numbers without it:" default items first item of defaultCountryCodes without multiple selections allowed and empty selection allowed
	if countryCodeToUse is false or first item of countryCodeToUse does not start with "+" then return false
	set countryCodeToUse to countryCodeToUse as text
	
	set numOfPhoneNumbersModified to 0
	repeat with i from 1 to 10
		set peopleToChange to (get people whose value of phone i is not missing value and value of phone i does not start with "+")
		set numOfPeopleToChange to count peopleToChange
		set thisPersonIdx to 1
		--	if number of items in peopleToChange = 0 then exit repeat
		-- set thisPerson to some item of peopleToChange
		repeat with thisPerson in peopleToChange
			log "[" & thisPersonIdx & "/" & numOfPeopleToChange & "] " & thisPerson's name
			set thePhoneNumber to phone i of thisPerson
			set oldNumber to thePhoneNumber's value
			set newNumber to oldNumber
			
			-- i18n phone number with country code			
			if countryCodeToUse is equal to "+82" then -- Korea, Republic of:
				-- 15{??,66,77,88,99,??}-???? needs a 02- prefix
				if newNumber starts with "15" and length of my normalizeText(newNumber, decimalDigits) = 8 then set newNumber to "02-" & newNumber as text
				-- Standard numbers need to strip the leading 0: 02-???-????, 031-???-????, 010-9???-????, ...
				if newNumber starts with "0" then
					set newNumber to text 2 thru end of newNumber
					-- Prefix with country code
					set newNumber to countryCodeToUse & " " & newNumber as text
				end if
			else if countryCodeToUse is equal to "+1" then -- USA
				-- simply prefix the country code
				if length of my normalizeText(newNumber, decimalDigits) = 3 + 3 + 4 then set newNumber to countryCodeToUse & " " & newNumber as text
			else -- Other countries:
				-- simply prefix the country code
				set newNumber to countryCodeToUse & " " & newNumber as text
			end if
			
			if newNumber starts with countryCodeToUse and newNumber is not equal to oldNumber then
				log "  (" & thePhoneNumber's label & "): " & thePhoneNumber's value & " -> " & newNumber
				-- Enable to debug: return
				set thePhoneNumber's value to newNumber
				save
				set numOfPhoneNumbersModified to numOfPhoneNumbersModified + 1
			end if
			set thisPersonIdx to thisPersonIdx + 1
		end repeat
	end repeat
	
	display dialog "Modified " & numOfPhoneNumbersModified & " phone numbers" with title "Internationalize Phone Numbers"
end tell

on normalizeText(str, allowedChars)
	local c, str2
	set str2 to ""
	repeat with c in characters of str
		if allowedChars contains c then set str2 to str2 & c
	end repeat
	return str2
end normalizeText

-- from http://macscripter.net/viewtopic.php?id=33850
on replace(t, d1, d2)
	local oTIDs, l
	set oTIDs to AppleScript's text item delimiters
	set AppleScript's text item delimiters to d1
	set l to text items of t
	set AppleScript's text item delimiters to d2
	set t to l as text
	set AppleScript's text item delimiters to oTIDs
	return t
end replace
