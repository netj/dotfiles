# AppleScript for toggling iPhone Tethering over an ad-hoc Wi-Fi using the SOCKS.app
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-06-09
# See-Also SOCKS.app:   http://code.google.com/p/iphone-socks-proxy/
# See-Also Inspiration: http://macscripter.net/viewtopic.php?id=38289
#
# TODO: proxy full TCP and/or IP: 1) using redsocks with pf/ipfw, or 2) ?

-------------------------------------------------------------------------------------------------

-- Configuration is saved in user's home directory

set scriptFile to POSIX file ((POSIX path of (path to home folder)) & ".iPhoneTetherConfig.scpt")
tell application "Finder"
	if not (scriptFile exists) then
		script defaultConfig
			-- Configuration for Toggle iPhone Tethering applescript
			property iPhoneHostname : "iPhone.local" -- Your iPhone's name ending with ".local", or its IP address
			property iPhoneSOCKSPort : 1080 -- the port your SOCKS app is listening to
			property NetworkName : "MacNiPhone" -- the ad-hoc Wi-Fi name to use between your Mac and iPhone
			property NetworkPassword : "abcdefghij123" -- 13 ASCII character passphrase for WEP
			property LocationName : "iPhone Tethering" -- Name to use for your Mac's network location (can be anything)
			property DefaultLocationName : "Automatic"
		end script
		store script defaultConfig in scriptFile replacing yes
		activate
		display alert "Please rerun after configuring ~/.iPhoneTetherConfig.scpt."
		open scriptFile
		error "~/.iPhoneTetherConfig.scpt should be configured"
	end if
end tell
property Config : missing value
set Config to load script scriptFile

-------------------------------------------------------------------------------------------------

-- UI strings -- You may need to localize
script UI_en
	property MenuItemHint : "Wi-Fi"
	property TurnOnMenu : "Turn Wi-Fi On"
	property CreateNetworkMenu : "Create Networkˇ"
	property CreateButton : "Create"
	to LeaveNetworkMenu(NetworkName)
		return "Disconnect from " & NetworkName
	end LeaveNetworkMenu
end script
script UI_ko
	property MenuItemHint : "Wi-Fi"
	property TurnOnMenu : "Wi-Fi 难扁"
	property CreateNetworkMenu : "匙飘况农 积己ˇ"
	property CreateButton : "积己"
	to LeaveNetworkMenu(NetworkName)
		return NetworkName & "俊辑 楷搬 秦力"
	end LeaveNetworkMenu
end script

-- and choose one from below
property UI : UI_en
set UI to UI_ko

-------------------------------------------------------------------------------------------------

-- How to switch to a network location
to switchToLocation(loc)
	if loc is equal to (Config's LocationName) then
		set cmd to "
		set -eux
		wifi=\"Wi-Fi\"
		loc='" & loc & "'
		networksetup -switchtolocation \"$loc\" || {
			# create a location if not exists
			networksetup -createlocation \"$loc\" populate
			networksetup -switchtolocation \"$loc\"
		}
		# make sure only Wi-Fi is being used
		networksetup -listallnetworkservices | grep -v \"^$wifi$\" |
		while read svc; do networksetup -setnetworkserviceenabled \"$svc\" off; done
		# make sure SOCKS proxy is set correctly
		networksetup -setsocksfirewallproxy \"$wifi\" '" & (Config's iPhoneHostname) & "' " & (Config's iPhoneSOCKSPort) & "
		networksetup -setsocksfirewallproxystate \"$wifi\" on
		"
	else
		set cmd to "networksetup -switchtolocation '" & loc & "'"
	end if
	activate
	do shell script cmd with administrator privileges
end switchToLocation

-- How to find the Wi-Fi Menu
to findWiFiMenu()
	local theMenu, menuExtras
	tell application "System Events"
		tell process "SystemUIServer"
			tell menu bar 1
				set menuExtras to value of attribute "AXDescription" of menu bar items
				repeat with theMenu from 1 to the count of menuExtras
					if item theMenu of menuExtras contains (UI's MenuItemHint) then exit repeat
				end repeat
				return theMenu
			end tell
		end tell
	end tell
end findWiFiMenu


tell application "System Events"
	tell process "SystemUIServer"
		tell menu bar 1
			set theMenu to my findWiFiMenu()
			tell menu bar item theMenu
				perform action "AXPress"
				-- If Wi-Fi is off, turn it on
				if title of menu item 2 of menu 1 is (UI's TurnOnMenu) then
					perform action "AXPress" of menu item (UI's TurnOnMenu) of menu 1
					perform action "AXPress"
				end if
				-- Wi-Fi menu takes some time to reflect current information, so we'd better wait a few secs if the network is not already there
				try
					set connectMenuItem to menu item (Config's NetworkName) of menu 1
				on error
					delay 4 -- it takes about ~3 secs for an initial scan
				end try
				-- Now, see if we're already connected to the Wi-Fi network we were to create
				try
					set leaveMenuItem to menu item (UI's LeaveNetworkMenu((Config's NetworkName))) of menu 1
				on error
					set leaveMenuItem to null
				end try
				if leaveMenuItem is not null then
					-- Then, simply disconnect from the network and restore location
					perform action "AXPress" of leaveMenuItem
					return my switchToLocation(Config's DefaultLocationName)
				else
					-- Otherwise, see if the network was already there
					try
						set connectMenuItem to menu item (Config's NetworkName) of menu 1
					on error
						set connectMenuItem to null
					end try
					if connectMenuItem is not null then
						-- Then, just connect to it and switch location
						perform action "AXPress" of connectMenuItem
						return my switchToLocation((Config's LocationName))
					else
						-- or, create the network
						perform action "AXPress" of menu item (UI's CreateNetworkMenu) of menu 1
					end if
				end if
			end tell
		end tell
		
		-- Enter information into Create Network Dialog
		tell window 1
			click pop up button 2
			click menu item 4 of menu 1 of pop up button 2
			set value of text field 3 to (Config's NetworkPassword)
			set value of text field 2 to (Config's NetworkPassword)
			set value of text field 1 to (Config's NetworkName)
			click button (UI's CreateButton)
		end tell
		-- Finally, switch location
		return my switchToLocation((Config's LocationName))
	end tell
end tell

# vim:ft=applescript:ts=4:sts=4:sw=4
