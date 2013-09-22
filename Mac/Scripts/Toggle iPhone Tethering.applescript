# AppleScript for toggling iPhone Tethering over an ad-hoc Wi-Fi using the SOCKS.app
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-06-09
# See-Also SOCKS.app:   http://code.google.com/p/iphone-socks-proxy/
# See-Also Inspiration: http://macscripter.net/viewtopic.php?id=38289
#
# TODO: proxy full TCP and/or IP: 1) using redsocks with pf/ipfw, or 2) ?

-------------------------------------------------------------------------------------------------

-- UI strings -- You may need to localize
script UI_en
	property MenuItemHint : "Wi-Fi"
	property TurnOnMenu : "Turn Wi-Fi On"
	property CreateNetworkMenu : "Create Network…"
	property CreateButton : "Create"
	to LeaveNetworkMenu(NetworkName)
		return "Disconnect from " & NetworkName
	end LeaveNetworkMenu
end script
script UI_ko
	property MenuItemHint : "Wi-Fi"
	property TurnOnMenu : "Wi-Fi 켜기"
	property CreateNetworkMenu : "네트워크 생성…"
	property CreateButton : "생성"
	to LeaveNetworkMenu(NetworkName)
		return NetworkName & "에서 연결 해제"
	end LeaveNetworkMenu
end script

-- and choose one from below
property UI : UI_en
property Config : missing value
property LastUsedPort : 20000

-------------------------------------------------------------------------------------------------

-- How to join an ad-hoc Wi-Fi network
to startAdHocWiFiForTethering(Config)
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
					-- See if we were already connected to the ad-hoc network
					try
						set leaveMenuItem to menu item (UI's LeaveNetworkMenu((Config's NetworkName))) of menu 1
						perform action "AXPress"
						return false
					end try
					-- Wi-Fi menu takes some time to reflect current information, so we'd better wait a few secs if the network is not already there
					try
						set connectMenuItem to menu item (Config's NetworkName) of menu 1
					on error
						delay 4 -- it takes about ~3 secs for an initial scan
					end try
					try
						set connectMenuItem to menu item (Config's NetworkName) of menu 1
					on error
						set connectMenuItem to null
					end try
					if connectMenuItem is not null then
						-- Then, just connect to it
						perform action "AXPress" of connectMenuItem
						return true
					else
						-- Or, create the ad-hoc network
						perform action "AXPress" of menu item (UI's CreateNetworkMenu) of menu 1
					end if
				end tell
			end tell
			tell window 1
				click pop up button 2
				click menu item 4 of menu 1 of pop up button 2
				set value of text field 3 to (Config's NetworkPassword)
				set value of text field 2 to (Config's NetworkPassword)
				set value of text field 1 to (Config's NetworkName)
				click button (UI's CreateButton)
			end tell
			return true
		end tell
	end tell
end startAdHocWiFiForTethering

-- How to disconnect from an ad-hoc Wi-Fi network
to stopAdHocWiFiForTethering(Config)
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
					-- See if we were already connected to the ad-hoc network
					try
						set leaveMenuItem to menu item (UI's LeaveNetworkMenu((Config's NetworkName))) of menu 1
						-- Disconnect from the ad-hoc network if needed
						perform action "AXPress" of leaveMenuItem
						delay 1
						return true
					on error
						perform action "AXPress"
					end try
				end tell
			end tell
		end tell
		return false
	end tell
end stopAdHocWiFiForTethering

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

-------------------------------------------------------------------------------------------------

-- How to switch to a network location
to switchToLocation(loc, port)
	if loc is (do shell script "networksetup -getcurrentlocation") then
		-- already configured, no need to run any further command
		return true
	end if
	if loc is equal to (Config's LocationName) then
		set cmd to "
		set -eux
		wifi=\"Wi-Fi\"
		loc=" & (quoted form of loc) & "
		networksetup -switchtolocation \"$loc\" || {
			# create a location if not exists
			networksetup -createlocation \"$loc\" populate
			networksetup -switchtolocation \"$loc\"
		}
		# make sure only Wi-Fi is being used
		networksetup -listallnetworkservices | grep -vxF \"$wifi\" |
		while read svc; do networksetup -setnetworkserviceenabled \"$svc\" off; done
		# make sure SOCKS proxy is set correctly
		networksetup -setsocksfirewallproxy \"$wifi\" " & (quoted form of Config's iPhoneHostname) & " " & (quoted form of (port as text)) & "
		networksetup -setsocksfirewallproxystate \"$wifi\" on
		"
		activate
		do shell script cmd with administrator privileges
	else
		set cmd to "networksetup -switchtolocation '" & loc & "'"
	end if
	activate
	do shell script cmd with administrator privileges
end switchToLocation

-------------------------------------------------------------------------------------------------

on run {}
	-- TODO determine UI based on AppleLanguage
	set UI to UI_ko
	
	-- Configuration is saved in user's home directory
	set scriptFile to POSIX file ((POSIX path of (path to home folder)) & ".iPhoneTetherConfig.scpt")
	tell application "Finder"
		if not (scriptFile exists) then
			script defaultConfig
				-- Configuration for Toggle iPhone Tethering applescript
				property iPhoneHostname : "iPhone.local" -- Your iPhone's name ending with ".local", or its IP address
				property iPhoneSOCKSPorts : {20000, 30000, 40000} -- the ports your SOCKS app is listening to
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
	set Config to load script scriptFile
	
	set buttonNames to {ok:"Setup my Mac", cancel:"Quit"}
	repeat
		try
			-- ask which port to use
			set ports to choose from list (Config's iPhoneSOCKSPorts) ¬
			    with title "iPhone Tethering Toggler" ¬
				with prompt "Choose the port \"Tethering\" app on your iPhone is showing:
(If it's \"n/a\", Start it first!)" ¬
                default items {LastUsedPort} ¬
				OK button name buttonNames's ok ¬
				cancel button name buttonNames's cancel
			if ports is false then exit repeat
			set {iPhoneSOCKSPort} to ports
			set LastUsedPort to iPhoneSOCKSPort
			set iPhoneSOCKSPort to iPhoneSOCKSPort as number
			startAdHocWiFiForTethering(Config)
			switchToLocation(Config's LocationName, iPhoneSOCKSPort)
			-- show informational dialog
			set buttonNames to {ok:"Change Port", cancel:"End Tethering"}
			try
				set iPhoneHostIPAddress to do shell script "
					host=" & (quoted form of Config's iPhoneHostname) & "
					ip=`ping -t1 -c1 \"$host\" | head -1 | sed 's/.*(\\([^)]*\\)).*/\\1/'`
					echo \"${ip:+ aka. $ip}\""
				activate
				set nextStep to ¬
				    display alert "Your Mac is now ready to use your iPhone's Internet connection!" ¬
                        & " (as a SOCKS proxy at " & (Config's iPhoneHostname) & iPhoneHostIPAddress & " port " & iPhoneSOCKSPort & ")" ¬
                    message "
1. Make sure your iPhone's Wi-Fi is connected to \"" & (Config's NetworkName) & "\" (password: " & (Config's NetworkPassword) & ").
2. Keep the \"Tethering\" app on your iPhone foreground and don't forget to \"Start\" it.
3. If the port shown on your app is different than \"" & iPhoneSOCKSPort & "\", use the Change Port button on this dialog.
4. Otherwise, enjoy your tethering and End Tethering when done.
" ¬
                    buttons {buttonNames's cancel, buttonNames's ok} ¬
                    as informational ¬
					default button buttonNames's ok cancel button buttonNames's cancel
				if nextStep's button returned is not buttonNames's ok then exit repeat
			on error
				exit repeat
			end try
		on error e
			display alert e as warning
			exit repeat
		end try
	end repeat
	stopAdHocWiFiForTethering(Config)
	switchToLocation(Config's DefaultLocationName, null)
	true
end run

# vim:ft=applescript:ts=4:sts=4:sw=4
