# AppleScript for organizing position and size of windows automatically in my Mac
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-06-09

--------------------------------------------------------------------------------------------------------

on Screen(w, h)
	return {size:{w, h}, origin:{0, 0}, visibleSize:{w, h}, visibleOrigin:{0, 0}}
end Screen

property macbookDisplay : Screen(1680, 1050)
property syncmaster27inDisplay : Screen(1920, 1200)
property syncmaster30inDisplay : Screen(2560, 1600)
property cinema30inDisplay : Screen(2560, 1600)
property thunderboltDisplay : Screen(2560, 1440)
property detectionTolerance : 100 -- px of alignment error to tolerate

--------------------------------------------------------------------------------------------------------

on use(screen, x, y)
	return {screen:screen, x:x, y:y}
end use

script macbookConfiguration
	property name : "MacBook"
	property screenLayout : {use(macbookDisplay, 0, 0)}
	on prepare()
		my hideDock(true)
	end prepare
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.98, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script homeConfiguration
	property name : "Home"
	-- a SyncMaster 275T is at my home desk
	property screenLayout : {use(syncmaster27inDisplay, 0, 0), use(macbookDisplay, 133, 1200)}
	on prepare()
		my hideDock(false)
	end prepare
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.95, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script gatesOfficeConfiguration
	property name : "Gates Office"
	-- I have a SyncMaster 305T in my office :)
	property screenLayout : {use(syncmaster30inDisplay, 0, 0), use(macbookDisplay, 2560, 1315)}
	on prepare()
		my hideDock(false)
	end prepare
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script meyerConfiguration
	property name : "Meyer Library"
	-- There are 30-in Cinema Displays
	property screenLayout : {use(cinema30inDisplay, 0, 0), use(macbookDisplay, 440, 1600)}
	on prepare()
		my hideDock(false)
	end prepare
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script mpkOfficeConfiguration
	property name : "MPK Office"
	-- There's an Apple Thunderbolt Display at my workplace
	property screenLayout : {use(thunderboltDisplay, 0, 0), use(macbookDisplay, 2560, 702)}
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

property configurations : {}
property currentConfiguration : macbookConfiguration
property mainScreen : macbookDisplay

--------------------------------------------------------------------------------------------------------

on run args
	tell application "System Events"
		-- enable UI scripting
		set UI elements enabled to true
		-- wait while screen saver is there
		repeat while true
			try
				get process "ScreenSaverEngine"
			on error
				exit repeat
			end try
			delay 1
		end repeat
	end tell
	
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
	useConfiguration(gatesOfficeConfiguration)
	useConfiguration(meyerConfiguration)
	useConfiguration(mpkOfficeConfiguration)
	determineCurrentConfiguration(args)
	
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
		my moveAndResize({screen:macbookDisplay, x:0, y:0, w:1532, h:1, wins:windows of message viewers})
		my switchToDesktopNumber(1)
		activate
		my keepInAllSpaces(message viewers, numScreens > 1)
	end tell
	set messagesAppName to "Messages"
	if (get version of application "Finder") < "10.8" then set messagesAppName to "iChat"
	if my appIsRunning(messagesAppName) then
		if my appIsRunning("Mail") then tell application "Mail" to my moveAndResize({screen:macbookDisplay, h:0.9, wins:windows of message viewers})
		tell application messagesAppName
			my moveAndResize({screen:macbookDisplay, x:0, y:1, h:700, wins:windows})
			my keepInAllSpaces(windows, numScreens > 1)
			try
				set buddiesWindows to windows whose name is "대화 상대" or name is "Buddies"
				my moveAndResize({screen:macbookDisplay, x:1, y:0, h:1, wins:buddiesWindows})
				my keepInAllSpaces(buddiesWindows, yes)
			end try
		end tell
	end if
	if my appIsRunning("Twitter") then tell application "Twitter" to my moveAndResize({screen:macbookDisplay, x:1, y:0, h:1, wins:windows})
	if my appIsRunning("Adium") then tell application "Adium"
		if my appIsRunning("Mail") then tell application "Mail" to my moveAndResize({screen:macbookDisplay, h:0.9, wins:windows of message viewers})
		my moveAndResize({screen:macbookDisplay, x:1, y:0, w:250, h:1, wins:windows})
		my moveAndResize({screen:macbookDisplay, x:1, y:1, w:0.6, h:0.75, wins:chat windows})
		my keepInAllSpaces(chat windows, numScreens > 1)
	end tell
	
	if my appIsRunning("Eclipse") then moveAndResize({x:0, y:0, w:1, h:1, wins:my getAppWindows("Eclipse")})
	
	if my appIsRunning("Skim") then tell application "Skim" to my moveAndResize({wins:windows, w:0.6, h:1})
	if my appIsRunning("Papers2") then moveAndResize({x:0, y:0, wins:my getAppWindows("Papers2"), w:1, h:1})
	
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
	set screenIndex to 0
	repeat with placement in currentConfiguration's screenLayout
		set screen to placement's screen
		set {w, h} to screen's size
		set screenDim to w & "x" & h
		set screenNumber to ""
		try
			set screenNumber to screen's screenNumber
		end try
		set cmd to "~/Library/Scripts/NSScreen.py " & screenDim & " " & screenNumber & " -- X Y  Xvisible Yvisible  Wvisible Hvisible"
		#log cmd
		set screenInfo to do shell script cmd
		set delimiter to the text item delimiters
		set the text item delimiters to ASCII character 13
		if (count (text items of screenInfo)) = 6 then
			#log {cmd, text items of screenInfo}
			set {x,y, xv,yv, wv,hv} to text items of screenInfo
			set placement's x to x as number
			set placement's y to y as number
			set screen's visibleOrigin to {xv as number, yv as number}
			set screen's visibleSize to {wv as number, hv as number}
			set NSScreenWorked to true
		end if
		set the text item delimiters to delimiter
		set screenIndex to screenIndex + 1
	end repeat
	
	set mainScreen to first item's screen of currentConfiguration's screenLayout
	
	# use a workaround if NSScreen.py didn't work
	if not NSScreenWorked then adjustScreenWithDock(mainScreen)
	
	return currentConfiguration
end determineCurrentConfiguration

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
	log "activating " & appDockName
	tell application "System Events"
		try
			set appDockIcon to get UI element appDockName of list 1 of process "Dock"
			click appDockIcon
			click appDockIcon
			delay 0.3
		on error
			set windowMenu to (first menu bar item whose title is "Window" or title is "윈도우") of menu bar 1 of process appName
			click last menu item of menu 1 of windowMenu
		end try
	end tell
end getAppIntoView

-- How to get window into view
on getAppWindowIntoView(appName, windowName)
	log "activating " & appName & "'s window named: " & windowName
	tell application appName to activate
	tell application "System Events" to tell process appName
		try
			set windowMenuItem to menu item windowName of menu 1 of (first menu bar item whose title is "Window" or title is "윈도우") of menu bar 1
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
		--log ("moveAndResize "& _x &" "& _y &" "& _w &" "& _h &"\t"& (win's name))
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
				-- ⌃⇧⌘F
				key code 3 using {command down, control down, shift down}
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
					tell me to log "switching to desktop " & num
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
	tell application "System Events"
		tell dock preferences
			set autohide to hide
			set magnification to (not hide)
		end tell
	end tell
end hideDock

# vim:ft=applescript:sw=4:ts=4:sts=4:noet
