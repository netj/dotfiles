-- An AppleScript to Toggle Internet Sharing
-- Derived-From: http://stackoverflow.com/a/4748328/390044

-- set internetSharingRowNumber to 11 -- prior to Lion
set internetSharingRowNumber to 9 -- Mountain Lion


tell application "System Preferences"
    activate
    reveal (pane id "com.apple.preferences.sharing")
end tell

tell application "System Events"
    tell process "System Preferences"
        try
            set internetSharingRow to row internetSharingRowNumber of table 1 of scroll area 1 of group 1 of window 1 -- "Sharing"
            set internetSharingServiceName to value of UI element 2 of internetSharingRow
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

            activate (display alert (internetSharingServiceName & " " & internetSharingStatus) giving up after 1)

        on error err
            activate
            display alert "Couldn't toggle Internet Sharing." message err & "\n\nYou may need to edit the internetSharingRowNumber value in the script." as critical
            return false
        end try

    end tell

end tell
