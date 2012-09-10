-- An AppleScript to Toggle Internet Sharing
-- Derived-From: http://stackoverflow.com/a/4748328/390044

-- the name of the sharing item
set internetSharingServiceNames to { "Internet Sharing", "인터넷 공유" }


tell application "System Preferences"
    activate
    reveal (pane id "com.apple.preferences.sharing")
end tell

tell application "System Events"
    tell process "System Preferences"
        try
            set internetSharingRow to null
            repeat with r in rows of table 1 of scroll area 1 of group 1 of window 1
                set rowLabel to value of UI element 2 of r
                if rowLabel is in internetSharingServiceNames then
                    set internetSharingRow to r
                    exit repeat
                end if
            end repeat
            if internetSharingRow = null then return
                
            set internetSharingWasOff to ((get value of checkbox of internetSharingRow) - 1) < 0
            click checkbox of internetSharingRow

            if internetSharingWasOff then
                set internetSharingStatus to "ON"
                repeat until sheet of window 1 exists
                    delay 0.5
                end repeat
                if (sheet of window 1 exists) then click button 2 of sheet of window 1
            else
                set internetSharingStatus to "OFF"
            end if

            tell application "System Preferences" to quit

            activate (display alert (rowLabel & " " & internetSharingStatus) giving up after 1)

        on error err
            activate
            display alert "Couldn't toggle Internet Sharing." message err & "\n\nYou may need to modify the internetSharingServiceNames variable in the script." as critical
            return false
        end try

    end tell

end tell
