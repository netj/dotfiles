#!/usr/bin/env osascript
## HelloDisplays for MacBook
# 
# Are you manually rearranging a pile of windows to their ideal positions and
# sizes every time you plug an external display to your MacBook? Free yourself
# from such hassle with HelloDisplays and some AppleScript!
# 
# This AppleScript provides plenty of vocabularies for moving positions of
# windows and resizing them.  You can define a number of display arrangement
# configurations and have sophisticated rules attached to each of them, which
# describes how you would have manually laid out windows of different apps
# across displays.  HelloDisplays will detect which configuration you are in,
# and apply the rules for that configuration.
# 
# With the help of another script called watch-syslog.sh, you can add the
# following two lines to your crontab (see `crontab -e`) to automatatically
# trigger HelloDisplays as you connect or disconnect external displays.
# 
#     */19 *   * * *   watch-syslog.sh -e 1000 'WindowServer\[[0-9]\+\]: Display '  ~/.HelloDisplays.pid  exec ~/Library/Scripts/HelloDisplay.sh  &>/dev/null &
#     @reboot          watch-syslog.sh -e 1000 'WindowServer\[[0-9]\+\]: Display '  ~/.HelloDisplays.pid  exec ~/Library/Scripts/HelloDisplay.sh  &>/dev/null &
# 
# Enjoy!
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-06-09

--------------------------------------------------------------------------------------------------------

on Screen(w, h)
	return {size:{w, h}, origin:{0, 0}, visibleSize:{w, h}, visibleOrigin:{0, 0}}
end Screen

property macbookDisplay : Screen(1920, 1200)
property syncmaster27inDisplay : Screen(1920, 1200)
property syncmaster30inDisplay : Screen(2560, 1600)
property cinema30inDisplay : Screen(2560, 1600)
property thunderboltDisplay : Screen(2560, 1440)
property dellUhdWideDisplay : Screen(3440, 1440)
property detectionTolerance : 200 -- px of alignment error to tolerate

--------------------------------------------------------------------------------------------------------

on place(screen, x, y)
	return {screen:screen, x:x, y:y}
end place

script macbookConfiguration
	property name : "MacBook"
	property screenLayout : {place(macbookDisplay, 0, 0)}
	on prepare()
		set {w,h} to macbookDisplay's size
		my hideDock(w < 1680)
	end prepare
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.98, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script homeConfiguration
	property name : "Home"
	-- an iMac 27" (equiv. to a Thunderbolt Display) is at my home desk
	property screenLayout : {place(thunderboltDisplay, 0, 0), place(macbookDisplay, 100, 1440)}
	on prepare()
		my hideDock(false)
	end prepare
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.95, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script latticeOfficeConfiguration
	property name : "Lattice Office"
	-- There's an Dell U3415W display at my workplace
	property screenLayout : {place(dellUhdWideDisplay, 0, 0), place(macbookDisplay, 3440-300, 1440)}
	on prepare()
		my hideDock(false)
	end prepare
	on adapt()
		--if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script gatesOfficeConfiguration
	property name : "Gates Office"
	-- I have a SyncMaster 305T in my office :)
	property screenLayout : {place(syncmaster30inDisplay, 0, 0), place(macbookDisplay, 440, 1600)}
	on prepare()
		my hideDock(false)
	end prepare
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

property configurations : {}
property currentConfiguration : macbookConfiguration
property mainScreen : macbookDisplay

--------------------------------------------------------------------------------------------------------

on run args

	-- make sure args is a list, since the rest relies on that
	if class of args is not list then
		set args to {}
	end if

	tell application "System Events"
		-- enable UI scripting
		-- set UI elements enabled to true -- XXX unsupported in OS X >= 10.9
		-- wait while screen saver is there
		repeat while true
			try
				get first process whose name is "ScreenSaverEngine"
			on error
				exit repeat
			end try
			delay 1
		end repeat
	end tell

	showProgressNotification(null)
	
	-- remember current application
	set curAppName to short name of (info for (path to frontmost application))
	set curWinName to null
	try
		set curWinName to front window's name of application curAppName
	end try
	log "* Current Application: " & curAppName
	if curWinName is not null then log "* Current Window: " & curWinName
	
	-- define configurations and pick one
	set configurations to {}
	useConfiguration(macbookConfiguration)
	useConfiguration(homeConfiguration)
	useConfiguration(latticeOfficeConfiguration)
	useConfiguration(gatesOfficeConfiguration)
	determineCurrentConfiguration(args)
	
	showProgressNotification(currentConfiguration)
	
	if args is not {} then log {"* Command-Line arguments: "} & args
	log "* Detected context: " & currentConfiguration's name
	log "* Screen size: " & (actualWidth & " x " & actualHeight)
	set screenIndex to 0
	repeat with placement in currentConfiguration's screenLayout
		set {w, h} to placement's screen's visibleSize
		set {x, y} to placement's screen's visibleOrigin
		log "  * Screen " & screenIndex & ": " & w & " x " & h & " at (" & x & ", " & y & ")"
		set screenIndex to screenIndex + 1
	end repeat
	set numScreens to screenIndex



	-- move and resize some apps (without knowing the environment)
	if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({w:1321, wins:my getLargeEnoughWindows(windows)})
	
	-- environment specific move/resizes
	currentConfiguration's adapt()
	
	-- move and resize some apps
	if my appIsRunning("Mail") then tell application "Mail"
		my rememberVisibility("Mail")
		my moveAndResize({screen:macbookDisplay, x:0, y:0, w:1352, h:1, wins:windows of message viewers})
		my switchToDesktopNumber(1)
		activate
		my keepInAllSpaces(message viewers, numScreens > 1)
		my preserveVisibility("Mail")
	end tell
	set messagesAppName to "Messages"
	-- if (get version of application "Finder") < "10.8" then set messagesAppName to "iChat" # XXX broken since 10.10
	if my appIsRunning(messagesAppName) then
		if my appIsRunning("Mail") then tell application "Mail" to my moveAndResize({screen:macbookDisplay, h:0.9, wins:windows of message viewers})
		my rememberVisibility(messagesAppName)
		tell application messagesAppName
			my moveAndResize({screen:macbookDisplay, x:0, y:1, h:700, wins:windows})
			my keepInAllSpaces(windows, numScreens > 1)
			try
				set buddiesWindows to windows whose name is "Buddies" ¬
				                                 or name is "대화 상대"
				my moveAndResize({screen:macbookDisplay, x:1, y:0, h:1, wins:buddiesWindows})
				my keepInAllSpaces(buddiesWindows, yes)
			end try
		end tell
		my preserveVisibility(messagesAppName)
	end if
	try
		if my appIsRunning("Slack") then
			-- my rememberVisibility("Slack") -- XXX causes an error
			tell application "Slack"
				tell application "System Events" to tell application process "Slack" to set ws to windows
				my moveAndResize({screen:macbookDisplay, x:1, y:0, w:0.67, h:1, wins:ws})
			end tell
		end if
	end try

	-- keep iTunes Mini Player on a corner of the MacBook screen
	if my appIsRunning("iTunes") then tell application "iTunes"
		my rememberVisibility("iTunes")
		tell application "System Events" to tell process "iTunes" to ¬
		    set miniPlayers to get windows whose title is "Mini Player" ¬
		                                      or title is "미니 플레이어"
		my moveAndResize({screen:macbookDisplay, x:0.45, y:0.97, wins:miniPlayers})
		my preserveVisibility("iTunes")
	end tell

	-- 3rd party apps
	try
		if my appIsRunning("Things") then tell application "Things"
			my rememberVisibility("Things")
			my moveAndResize({screen:macbookDisplay, x:1, y:1, wins:windows})
			my preserveVisibility("Things")
		end tell
	end try
	
	try
		if my appIsRunning("Skim") then tell application "Skim"
			my rememberVisibility("Skim")
			my moveAndResize({wins:windows, w:0.6, h:1})
			my preserveVisibility("Skim")
		end tell
	end try
	try
		if my appIsRunning("Papers") then
			my rememberVisibility("Papers")
			moveAndResize({x:0, y:0, wins:my getAppWindows("Papers"), w:1, h:1})
			my preserveVisibility("Papers")
		end if
	end try
	
	(*
	if my appIsRunning("Twitter") then tell application "Twitter" to my moveAndResize({screen:macbookDisplay, x:1, y:0, h:1, wins:windows})
	if my appIsRunning("Adium") then tell application "Adium"
		if my appIsRunning("Mail") then tell application "Mail" to my moveAndResize({screen:macbookDisplay, h:0.9, wins:windows of message viewers})
		my rememberVisibility("Adium")
		my moveAndResize({screen:macbookDisplay, x:1, y:0, w:250, h:1,    wins:windows whose name is     "Contacts"})
		my moveAndResize({screen:macbookDisplay, x:1, y:1, w:0.6, h:0.75, wins:windows whose name is not "Contacts"})
		my keepInAllSpaces(windows, numScreens > 1)
		my preserveVisibility("Adium")
	end tell
	*)
	
	try
		if my appIsRunning("Eclipse") then moveAndResize({x:0, y:0, w:1, h:1, wins:my getAppWindows("Eclipse")})
	end try

	-- get back to current application, and front window
	--	tell application curAppName to activate
	if curWinName is not null then my getAppWindowIntoView(curAppName, curWinName)
	
	return true
end run

--------------------------------------------------------------------------------------------------------

-- configurations

on useConfiguration(config)
	set end of configurations to config
end useConfiguration

property actualWidth : null
property actualHeight : null

on determineCurrentConfiguration(args)
	-- consider the screen size
	tell application "Finder" to set {_x, _y, actualWidth, actualHeight} to bounds of window of desktop
	set {actualWidth, actualHeight} to {actualWidth - _x, actualHeight - _y}

	-- detect the size of builtin display (TODO only if needed e.g., on differently scaled Retina displays)
		set {w,h} to my askNSScreen("builtin", "W H")
		set macbookDisplay's size to {w as number, h as number}
		set macbookDisplayUncertain to false
	
	-- determine which configuration to use
	set currentConfiguration to macbookConfiguration -- default
	if (count args) > 0 and (exists (configurations whose name = item 1 of args)) then
		set currentConfiguration to first item of (configurations whose name = item 1 of args)
		currentConfiguration's prepare()
	else
		repeat with config in configurations
			config's prepare()
			if actualScreensMatch(config) then
				set currentConfiguration to config
				exit repeat
			end if
		end repeat
	end if
	
	-- adjust display properties
	set NSScreenWorked to false
	repeat with placement in currentConfiguration's screenLayout
		set screen to placement's screen
		set {w, h} to screen's size
		set screenDim to w & "x" & h
		set screenIdentifier to ""
		try
			set screenIdentifier to screen's screenIdentifier
		end try
		try
			set {x,y, xv,yv, wv,hv} to my askNSScreen(screenDim & " " & screenIdentifier, "X Y  Xvisible Yvisible  Wvisible Hvisible")
			set xv to xv as number
			set yv to yv as number
			set wv to wv as number
			set hv to hv as number
			set placement's x to x as number
			set placement's y to y as number
			if yv = 22 and xv = 4 then
				set wv to wv + xv
				set xv to 0 # XXX NSScreen.py miscalculates Dock's width when autohide
			end if
			set screen's visibleOrigin to {xv, yv}
			set screen's visibleSize to {wv, hv}
			set NSScreenWorked to true
		end try
	end repeat
	
	set mainScreen to first item's screen of currentConfiguration's screenLayout
	
	# use a workaround if NSScreen.py didn't work
	if not NSScreenWorked then
		adjustScreenWithDock(mainScreen)
	end if
	
	return currentConfiguration
end determineCurrentConfiguration

-- A wrapper for NSScreen.py
on askNSScreen(screenQuery, fieldsToReturn)
	set numFields to count words of fieldsToReturn
	set cmd to "~/Library/Scripts/NSScreen.py " & screenQuery & " -- " & fieldsToReturn
	#log cmd
	set screenInfo to do shell script cmd
	set delimiter to the text item delimiters
	set the text item delimiters to ASCII character 13
	set values to text items of screenInfo
	set the text item delimiters to delimiter
	#log {cmd, values}
	if (count values) = numFields then
		return values
	else
		error "NSScreen could not retrieve all info for: " & screenQuery & " -- " & fieldsToReturn
	end if
end askNSScreen

on showProgressNotification(currentConfiguration)
	if currentConfiguration is null then
		display notification "HelloDisplays"  ¬
			with title "Detecting Config"  ¬
			subtitle "where we are..."
	else
		set cfg to get currentConfiguration's name
		display notification "HelloDisplays"  ¬
			with title "Found Config"  ¬
			subtitle "Rearranging windows for " & cfg & "..."
	end if
	(* XXX below need Growl to be installed
	tell application "System Events" to set isRunning to ¬
		(count of (every process whose bundle identifier is "com.Growl.GrowlHelperApp")) > 0
	if isRunning then
		tell application id "com.Growl.GrowlHelperApp"
			set the enabledNotificationsList to {"Detecting Config", "Found Config"}
			set the allNotificationsList to enabledNotificationsList & {}
			register as application "HelloDisplays"  ¬
				all notifications allNotificationsList  ¬
				default notifications enabledNotificationsList  ¬
				icon of application "Automator"
			if currentConfiguration is null then
				notify with name "Detecting Config" ¬
					title "Detecting"  ¬
					description "where we are..." ¬
					application name "HelloDisplays"
			else
				set cfg to get currentConfiguration's name
				notify with name "Found Config" ¬
					title "At " & cfg & "" ¬
					description "Rearranging windows for " & cfg & "..." ¬
					application name "HelloDisplays"
			end if
		end tell
	end if
	*)
end showProgressNotification

-- check if actual screen size matches config
on actualScreensMatch(config)
	set {minX,minY, maxX,maxY} to computeBounds(config's screenLayout)
	set {w,h} to {maxX - minX, maxY - minY}
	return abs(w - actualWidth) <= detectionTolerance and abs(h - actualHeight) <= detectionTolerance
end actualScreensMatch

on computeBounds(layout)
	set {minX,minY, maxX,maxY} to {0,0, 0,0}
	repeat with placement in layout
		set screen to placement's screen
		set screen's origin to {placement's x, placement's y}
		set {w,h} to screen's size
		set {x,y} to screen's origin
		if minX > x     then set minX to x
		if minY > y     then set minY to y
		if maxX < x + w then set maxX to x + w
		if maxY < y + h then set maxY to y + h
	end repeat
	return {minX,minY, maxX,maxY}
end computeBounds

on abs(v)
	if v < 0 then return -v
	return v
end abs

-- How to take Dock's size and position into account
property menubarHeight : 22 -- will probably stay constant, I guess
to adjustScreenWithDock(screen)
	tell application "System Events" to tell process "Dock"
		set {dockX, dockY} to position in list 1
		set {dockW, dockH} to size in list 1
	end tell
	set {x,y} to screen's origin
	set {w,h} to screen's size
	if dockX = 0 then -- dock is at left
		set screen's visibleOrigin to {dockW, menubarHeight}
		set screen's visibleSize to {w -dockW, h -menubarHeight}
	else if dockY + dockH ≥ item 2 of screen's size then
		set screen's visibleOrigin to {0, menubarHeight}
		set screen's visibleSize to {w, h -menubarHeight -dockH}
	else -- dock is at right
		set screen's visibleOrigin to {0, menubarHeight}
		set screen's visibleSize to {w -dockW, h -menubarHeight}
	end if
end adjustScreenWithDock


-- How to check if application is running
-- derived from: http://vgable.com/blog/2009/04/24/how-to-check-if-an-application-is-running-with-applescript/
on appIsRunning(appName)
	tell application "System Events" to return exists (processes where name is appName)
end appIsRunning

-- How to get application into view
on getAppIntoView(appName)
	tell application appName to activate
	set appDockName to displayed name of (info for (path to frontmost application))
	if appDockName ends with ".app" then set appDockName to characters 1 thru -5 of appDockName as text
	log "# activating " & appDockName
	tell application "System Events"
		try
			set appDockIcon to get UI element appDockName of list 1 of process "Dock"
			click appDockIcon
			click appDockIcon
			delay 0.3
		on error
			click last menu item of my getAppWindowMenu(appName)
		end try
	end tell
end getAppIntoView

-- How to get application's "Window" menu
-- XXX only works with English and Korean locales
on getAppWindowMenu(appName)
	tell application "System Events" to tell process appName
		return (menu 1 of (first menu bar item whose title is "Window" or title is "윈도우") of menu bar 1)
	end tell
end getAppWindowMenu

-- How to get window into view
on getAppWindowIntoView(appName, windowName)
	log "# activating " & appName & "'s window named: " & windowName
	tell application appName to activate
	tell application "System Events" to tell process appName
		try
			set windowMenuItem to menu item windowName of my getAppWindowMenu(appName)
			click windowMenuItem
			if "✓" is not the value of attribute "AXMenuItemMarkChar" of windowMenuItem then click windowMenuItem
			delay 0.2
			perform action "AXRaise" of window windowName
		on error
			set initialTitle to missing value
			repeat 10 times
				-- move desktops to find the window
				log "Looking for " & windowName & " of " & appName
				my getAppIntoView(appName)
				if get (count every windows) = 0 then exit repeat
				if front window's title is initialTitle then exit repeat
				if initialTitle is missing value then set initialTitle to front window's title
				try
					-- this will fail above if window is not visible on the current desktop
					perform action "AXRaise" of window windowName
					exit repeat
				end try
			end repeat
		end try
	end tell
end getAppWindowIntoView


-- How to get windows of applications not friendly to AppleScript/Events
on getAppWindows(appName)
	if my appIsRunning(appName) then
		tell application "System Events"
			repeat 120 times
				my getAppIntoView(appName)
				set appWindows to get windows of process appName
				if (count appWindows) > 0 then
					return appWindows
				else
					-- if the screen is locked, no papersWindows will be found, so repeat it
					delay 0.5
					-- TODO limit retry count
				end if
			end repeat
		end tell
	else
		return {}
	end if
end getAppWindows

on getLargeEnoughWindows(wins)
	return my filterWindows(wins, {minW:800, minH:600})
end getLargeEnoughWindows

on filterWindows(wins, cond)
	set cond to cond & {minW:null, minH:null, maxW:null, maxH:null}
	set satisfyingWindows to {}
	repeat with win in wins
		try
			set {x, y, x2, y2} to bounds of win
			set w to x2 - x
			set h to y2 - y
		on error
			set {x, y} to position of win
			set {w, h} to size of win
		end try
		try
			if cond's minW is not null and w < cond's minW then error 0
			if cond's maxW is not null and w > cond's maxW then error 0
			if cond's minH is not null and h < cond's minH then error 0
			if cond's maxH is not null and h > cond's maxH then error 0
			set end of satisfyingWindows to win
		end try
	end repeat
	return satisfyingWindows
end filterWindows


-- moveAndResize -- a piece of AppleScript for changing the size and position of windows
-- Author: Jaeho Shin <netj@sparcs.org>
-- Created: 2012-06-09
-- See: https://gist.github.com/2903884
(*
Running the following line will move and resize all windows of that application:

	tell application "Finder" to my moveAndResize(x,y, windows, w,h)

  
For x,y,w,h, you can pass:
* null, to leave it unchanged, or
* a number greater than 1 which is the actual number in pixels, or
* a ratio value ranging between 0 and 1, which will then
  reposition (or resize) relative to the remaining space (or entire screen size, respectively).

*)
to moveAndResize(args)
	-- Learned how to augment default values to a record from Nigel Garvey: http://macscripter.net/viewtopic.php?pid=139333#p139333
	set args to args & {wins:{}, screen:mainScreen, x:null, y:null, w:null, h:null}
	set wins to wins of args
	set screen to screen of args
	set newX to x of args
	set newY to y of args
	set newW to w of args
	set newH to h of args
	set {screenWidth, screenHeight} to screen's size
	try
		set {screenWidth, screenHeight} to screen's visibleSize
	end try
	set {offsetX, offsetY} to screen's origin
	try
		set {offsetX, offsetY} to screen's visibleOrigin
	end try
	repeat with win in wins
		-- see where window win is and how large it is
		try
			set {origX, origY, origX2, origY2} to bounds of win
			set {origW, origH} to {origX2 - origX, origY2 - origY}
		on error
			tell application "System Events"
				set {origX, origY} to get position of win
				set {origW, origH} to get size of win
			end tell
		end try
		set effWidth to screenWidth
		set effHeight to screenHeight
		
		-- first, figure out width and height
		set _w to origW
		if newW is not null then
			if newW ≤ 1 then -- scale
				set _w to newW * effWidth
			else
				set _w to newW
			end if
		end if
		set _h to origH
		if newH is not null then
			if newH ≤ 1 then
				set _h to newH * effHeight
			else
				set _h to newH
			end if
		end if
		
		-- then, the position
		set _x to origX
		if newX is not null then
			if newX ≤ 1 then
				set _x to offsetX + newX * (effWidth - _w)
			else
				set _x to offsetX + newX
			end if
		end if
		set _y to origY
		if newY is not null then
			if newY ≤ 1 then
				set _y to offsetY + newY * (effHeight - _h)
			else
				set _y to offsetY + newY
			end if
		end if
		
		-- change the size and position of the window
		log ("# moveAndResize "& _x &" "& _y &" "& _w &" "& _h ¬
		                  &"\t"& (win's name) ¬
		                  )
		try
			set bounds of win to {_x, _y, _x + _w, _y + _h}
		on error
			tell application "System Events"
				set position of win to {_x, _y}
				set size of win to {_w, _h}
			end tell
		end try
	end repeat
end moveAndResize


-- keepInAllSpaces -- Uses "Afloat" to keep window in all spaces
-- See: http://infinite-labs.net/afloat/
on keepInAllSpaces(wins, keepOrNot)
	set keepVal to 0
	if keepOrNot then set keepVal to 1
	repeat with w in wins
		activate w
		set appName to short name of (info for (path to frontmost application))
		my getAppWindowIntoView(appName, w's name)
		tell application "System Events"
			tell process appName
				try
					click menu item "Adjust Effects" of my getAppWindowMenu(appName)
					repeat 5 times
						try
							set afloatWindow to window "Afloat — Adjust Effects"
							tell afloatWindow
								set chkbox to checkbox "Keep this window on the screen on all Spaces"
								if chkbox's value is not keepVal then click chkbox
								click button "Done"
							end tell
							exit repeat
						end try
						delay 0.1
					end repeat
				end try
			end tell
		end tell
		return
	end repeat
end keepInAllSpaces


-- switchToDesktopNumber -- jumps to the desktop number
on switchToDesktopNumber(num)
	-- find key code from AppleSymbolicHotKeys for switching to Space 1 thru 9
	set symbolicKeyForSwitchingToSpace1 to 118
	try
		# See: http://hintsforums.macworld.com/showthread.php?t=114785
		# See: http://krypted.com/mac-os-x/defaults-symbolichotkeys/
		tell application "System Events"
			# See: http://www.j-schell.de/node/316
			set plist to property list file "~/Library/Preferences/com.apple.symbolichotkeys.plist"
			set AppleSymbolicHotKeys to plist's property list item "AppleSymbolicHotKeys"
			set symkeyName to (symbolicKeyForSwitchingToSpace1 + num-1) as string
			set symkey to AppleSymbolicHotKeys's property list item symkeyName
			set symkeyValue to symkey's property list item "value"
			if (symkey's property list item "enabled"'s value) and (symkeyValue's property list item "type"'s value) is "standard" then
				try
					set {ascii, code, m} to symkeyValue's property list item "parameters"'s value
					if not 0 = my BWAND(m, 2^17) then key down shift
					if not 0 = my BWAND(m, 2^18) then key down control
					if not 0 = my BWAND(m, 2^19) then key down option
					if not 0 = my BWAND(m, 2^20) then key down command
					tell me to log "# switching to desktop " & num
					key code code
				on error err
					tell me to log "Error: cannot switch to desktop " & num & ": " & err
				end try
				key up command
				key up option
				key up control
				key up shift
				return true
			end if
		end tell
	end try
	tell me to log "Error: no key bound for switching to desktop " & num
end switchToDesktopNumber

# See: https://gist.github.com/bassx/2227137
(* __int1 : integer
 * __int2 : integer
 * Integers are from 0 till 2 ^ 31 - 1. When integers become greater than 2 ^ 31 then they will become a real and the handler wont't work.
 *)
on BWAND(__int1, __int2)
	set theResult to 0
	repeat with bitOffset from 30 to 0 by -1
		if __int1 div (2 ^ bitOffset) = 1 and __int2 div (2 ^ bitOffset) = 1 then
			set theResult to theResult + 2 ^ bitOffset
		end if
		set __int1 to __int1 mod (2 ^ bitOffset)
		set __int2 to __int2 mod (2 ^ bitOffset)
	end repeat
	return theResult as integer
end BWAND

-- hideDock -- toggle autohide for Dock
on hideDock(hide)
	if hide then
		log "# dock: autohiding"
	else
		log "# dock: always showing"
	end if
	tell application "System Events"
		tell dock preferences
			set autohide to hide
			-- set magnification to (not hide) -- do not touch the option
		end tell
	end tell
end hideDock


-- shorthands for preserving visibility
property lastAppWasVisible : false
property lastAppsFrontWindowWasVisible : false
on rememberVisibility(appName)
	tell application "System Events" to set lastAppWasVisible to process appName's visible
	if lastAppWasVisible then
		tell application appName to set lastAppsFrontWindowWasVisible to front window's visible
	end if
end rememberVisibility
on preserveVisibility(appName)
	if lastAppWasVisible then
		tell application appName to set front window's visible to lastAppsFrontWindowWasVisible
	end if
	tell application "System Events" to set process appName's visible to lastAppWasVisible
end preserveVisibility

# vim:ft=applescript:sw=4:ts=4:sts=4:noet
