# AppleScript for organizing position and size of windows automatically in my Mac
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-06-09

--------------------------------------------------------------------------------------------------------

on Display(w, h)
	return {screenSize:{w, h}, baseCoords:{0, 0}, screenMargin:{0, 0}}
end Display

property macbookDisplay : Display(1680, 1050)
property syncmaster27inDisplay : Display(1920, 1200)
property syncmaster30inDisplay : Display(2560, 1600)
property thunderboltDisplay : Display(2560, 1440)

--------------------------------------------------------------------------------------------------------

on use(disp, x, y)
	return {disp:disp, x:x, y:y}
end use

script macbookConfiguration
	property name : "MacBook"
	property screens : {horizontal:{use(macbookDisplay, 0, 0)}}
	property defaultScreen : macbookDisplay
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.98, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script homeConfiguration
	property name : "Home"
	-- a SyncMaster 275T is at my home desk
	property screens : {vertical:{use(syncmaster27inDisplay, 0, 0), use(macbookDisplay, 133, 1200)}}
	property defaultScreen : syncmaster27inDisplay
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.95, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script gatesOfficeConfiguration
	property name : "Gates Office"
	-- I have a SyncMaster 305T in my office :)
	property screens : {horizontal:{use(syncmaster30inDisplay, 0, 0), use(macbookDisplay, 2560, 1315)}}
	property defaultScreen : syncmaster30inDisplay
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

script mpkOfficeConfiguration
	property name : "MPK Office"
	-- There's an Apple Thunderbolt Display at my workplace
	property screens : {horizontal:{use(thunderboltDisplay, 0, 0), use(macbookDisplay, 2560, 702)}}
	property defaultScreen : thunderboltDisplay
	on adapt()
		if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:my getLargeEnoughWindows(windows)})
	end adapt
end script

property configurations : {}
property currentConfiguration : macbookConfiguration
property defaultDisplay : macbookDisplay

--------------------------------------------------------------------------------------------------------

on run args
	tell application "System Events" to set UI elements enabled to true
	
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
	useConfiguration(mpkOfficeConfiguration)
	determineCurrentConfiguration(args)
	if args is not {} then log {"* Command-Line arguments: "} & args
	log "* Screen size: " & (actualWidth & " x " & actualHeight)
	log "* Detected context: " & currentConfiguration's name
	set screens to (currentConfiguration's screens & {horizontal:{}, vertical:{}})
	set numScreens to (screens's horizontal's length) + (screens's vertical's length)
	
	-- move and resize some apps (without knowing the environment)
	if my appIsRunning("Safari") then tell application "Safari" to my moveAndResize({w:1321, wins:my getLargeEnoughWindows(windows)})
	
	-- environment specific move/resizes
	currentConfiguration's adapt()
	
	-- move and resize some apps
	if my appIsRunning("Mail") then tell application "Mail"
		my moveAndResize({disp:macbookDisplay, x:0, y:0, w:1532, h:1, wins:windows of message viewers})
		my switchToDesktopNumber(1)
		my keepInAllSpaces(message viewers, numScreens > 1)
	end tell
	set messagesAppName to "Messages"
	if (get version of application "Finder") < "10.8" then set messagesAppName to "iChat"
	if my appIsRunning(messagesAppName) then
		if my appIsRunning("Mail") then tell application "Mail" to my moveAndResize({disp:macbookDisplay, h:0.9, wins:windows of message viewers})
		tell application messagesAppName
			my moveAndResize({disp:macbookDisplay, x:0, y:1, h:700, wins:windows})
			my keepInAllSpaces(windows, numScreens > 1)
			try
				set buddiesWindows to windows whose name is "대화 상대" or name is "Buddies"
				my moveAndResize({disp:macbookDisplay, x:1, y:0, h:1, wins:buddiesWindows})
				my keepInAllSpaces(buddiesWindows, yes)
			end try
		end tell
	end if
	if my appIsRunning("Twitter") then tell application "Twitter" to my moveAndResize({disp:macbookDisplay, x:1, y:0, h:1, wins:windows})
	if my appIsRunning("Adium") then tell application "Adium"
		if my appIsRunning("Mail") then tell application "Mail" to my moveAndResize({disp:macbookDisplay, h:0.9, wins:windows of message viewers})
		my moveAndResize({disp:macbookDisplay, x:1, y:0, w:250, h:1, wins:windows})
		my moveAndResize({disp:macbookDisplay, x:1, y:1, w:0.6, h:0.75, wins:chat windows})
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
	else
		repeat with config in configurations
			if actualScreensMatch(config) then
				set currentConfiguration to config
				exit repeat
			end if
		end repeat
	end if
	
	-- adjust other properties
	set defaultDisplay to currentConfiguration's defaultScreen
	adjustDisplayCoordinatesWithDock(defaultDisplay)
	
	return currentConfiguration
end determineCurrentConfiguration


-- check if actual screen size matches config
property detectionTolerance : 10 -- px of alignment error to tolerate
on actualScreensMatch(config)
	set screens to (config's screens) & {horizontal:null, vertical:null}
	-- first check actual width with horizontal screen config
	set hz to screens's horizontal
	if hz is not null then
		set totalW to 0
		set totalH to 0
		repeat with screen in hz
			set disp to screen's disp
			set disp's baseCoords to {screen's x, screen's y}
			set disp's screenMargin to {2, 2}
			set totalW to totalW + (item 1 of disp's screenSize)
			set newH to (item 2 of disp's screenSize) + (item 2 of disp's baseCoords)
			if newH > totalH then set totalH to newH
		end repeat
		if abs(totalW - actualWidth) > detectionTolerance or abs(totalH - actualHeight) > detectionTolerance then return false
	end if
	-- then check if actual height matches vertical screen config
	set vt to screens's vertical
	if vt is not null then
		set totalW to 0
		set totalH to 0
		repeat with screen in vt
			set disp to screen's disp
			set disp's baseCoords to {screen's x, screen's y}
			set disp's screenMargin to {2, 2}
			set newW to (item 1 of disp's screenSize) + (item 1 of disp's baseCoords)
			if newW > totalW then set totalW to newW
			set totalH to totalH + (item 2 of disp's screenSize)
		end repeat
		if abs(totalW - actualWidth) > detectionTolerance or abs(totalH - actualHeight) > detectionTolerance then return false
	end if
	return true
end actualScreensMatch

on abs(v)
	if v < 0 then return -v
	return v
end abs

-- How to take Dock's size and position into account
property menubarHeight : 22 -- will probably stay constant, I guess
to adjustDisplayCoordinatesWithDock(displayInfo)
	tell application "System Events" to tell process "Dock"
		set {dockX, dockY} to position in list 1
		set {dockW, dockH} to size in list 1
	end tell
	if dockX = 0 then -- dock is at left
		set displayInfo's baseCoords to {dockW, menubarHeight}
		set displayInfo's screenMargin to displayInfo's baseCoords
	else if dockY + dockH ≥ item 2 of displayInfo's screenSize then
		set displayInfo's baseCoords to {0, menubarHeight}
		set displayInfo's screenMargin to {0, menubarHeight + dockH}
	else -- dock is at right
		set displayInfo's baseCoords to {0, menubarHeight}
		set displayInfo's screenMargin to {dockW, menubarHeight}
	end if
end adjustDisplayCoordinatesWithDock


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
	set args to args & {wins:{}, disp:defaultDisplay, x:null, y:null, w:null, h:null}
	set wins to wins of args
	set displayInfo to disp of args
	set newX to x of args
	set newY to y of args
	set newW to w of args
	set newH to h of args
	set {screenWidth, screenHeight} to displayInfo's screenSize
	set {marginH, marginV} to displayInfo's screenMargin
	set {offsetX, offsetY} to displayInfo's baseCoords
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
		set effWidth to screenWidth - marginH
		set effHeight to screenHeight - marginV
		
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
-- This requires key mappings of ⌃⌥1, ⌃⌥2, ..., ⌃⌥0 from System Preferences
on switchToDesktopNumber(num)
	-- key codes for 1 thru 9, and 0
	log "switching to desktop " & num
	set keyCodeMapping to {18, 19, 20, 21, 23, 22, 26, 28, 25, 29}
	set k to item num of keyCodeMapping
	tell application "System Events" to key code k using {control down, option down}
end switchToDesktopNumber

# vim:ft=applescript:sw=4:ts=4:sts=4:noet
