# AppleScript for organizing position and size of windows automatically in my Mac
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-06-09

property menubarHeight : 22 -- will probably stay constant, I guess

script macbookDisplay
	property screenSize : {1680, 1050}
	property baseCoords : {51, 22}
	property screenMargin : baseCoords
end script

script syncmaster30inDisplay
	property screenSize : {2560, 1600}
	property baseCoords : {67, 22}
	property screenMargin : baseCoords
end script

script thunderboltDisplay
	property screenSize : {2560, 1440}
	property baseCoords : {67, 22}
	property screenMargin : baseCoords
end script

property defaultDisplay : macbookDisplay

on run args
	
	-- consider the screen size
	tell application "Finder" to set {_x, _y, _w, _h} to bounds of window of desktop
	
	set defaultDisplay to macbookDisplay
	if (count args) = 0 or not (item 1 of args is not in {"MacBook", "Gates Office", "MPK Office"}) then
		if _w = item 1 of macbookDisplay's screenSize and _h = item 2 of macbookDisplay's screenSize then
			set args to {"MacBook"}
		else if _h = (item 2 of macbookDisplay's screenSize) + (item 2 of syncmaster30inDisplay's screenSize) then
			set args to {"Gates Office"}
		else if _w = (item 1 of macbookDisplay's screenSize) + (item 1 of thunderboltDisplay's screenSize) then
			set args to {"MPK Office"}
		end if
	end if
	log args & _w & _h
	
	-- move and resize some apps (without knowing the environment)
	if appIsRunning("Safari") then tell application "Safari" to my moveAndResize({w:1321, wins:windows})
	
	-- decide the environment
	if "MacBook" is in args then
		adjustDisplayCoordinatesWithDock(defaultDisplay)
		-- some environment specific move/resizes
		if appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.98, wins:windows})
	else if "Gates Office" is in args then
		-- I have a SyncMaster 305T in my office :)
		set defaultDisplay to syncmaster30inDisplay
		adjustDisplayCoordinatesWithDock(defaultDisplay)
		-- adjust offset of macbookDisplay
		set macbookDisplay's screenMargin to {2, 2}
		set macbookDisplay's baseCoords to {484, 1600}
		-- some environment specific move/resizes
		if appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:windows})
	else if "MPK Office" is in args then
		-- There's an Apple Thunderbolt Display at my workplace
		set defaultDisplay to thunderboltDisplay
		adjustDisplayCoordinatesWithDock(defaultDisplay)
		-- adjust offset of macbookDisplay
		set macbookDisplay's screenMargin to {2, 2}
		set macbookDisplay's baseCoords to {2560, 702}
		-- some environment specific move/resizes
		if appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:windows})
	end if
	-- move and resize some apps
	
	if appIsRunning("Mail") then tell application "Mail" to my moveAndResize({disp:macbookDisplay, x:0, y:0, w:1532, h:0.9, wins:windows of message viewers})
	if appIsRunning("iChat") then tell application "iChat" to my moveAndResize({disp:macbookDisplay, x:0.9, y:0.9, h:700, wins:windows})
	if appIsRunning("Twitter") then tell application "Twitter" to my moveAndResize({disp:macbookDisplay, x:1, y:0, h:1, wins:windows})
	if appIsRunning("Adium") then tell application "Adium"
		my moveAndResize({disp:macbookDisplay, x:1, y:0, w:250, h:1, wins:windows})
		my moveAndResize({disp:macbookDisplay, x:1, y:1, w:0.6, h:0.75, wins:chat windows})
	end tell
	
	if appIsRunning("Eclipse") then moveAndResize({w:1, h:1, wins:getAppWindows("Eclipse")})
	
	if appIsRunning("Skim") then tell application "Skim" to my moveAndResize({wins:windows, w:0.6, h:1})
	if appIsRunning("Papers2") then moveAndResize({x:0, y:0, wins:getAppWindows("Papers2"), w:1, h:1})
	
	if appIsRunning("Mail") then
		tell application "Mail" to activate
		tell application "System Events" to key code 18 using command down -- Cmd-1 to goto inbox
	end if
	
end run

--------------------------------------------------------------------------------------------------------

-- How to take Dock's size and position into account
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
	tell application "System Events" to get exists (processes where name is appName)
end appIsRunning


-- How to get windows of applications not friendly to AppleScript/Events
on getAppWindows(appName)
	if appIsRunning(appName) then
		tell application "System Events"
			set appDockIcon to get UI element appName of list 1 of process "Dock"
			repeat
				tell application appName to activate
				click appDockIcon
				click appDockIcon
				delay 1
				set appWindows to get windows of process appName
				if (count appWindows) > 0 then
					return appWindows
				else
					-- if the screen is locked, no papersWindows will be found, so repeat it
					delay 5
					-- TODO limit retry count
				end if
			end repeat
		end tell
	else
		return {}
	end if
end getAppWindows

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


-- Move every window to main display
-- derived from: http://www.macosxtips.co.uk/index_files/move-all-windows-to-main-display.php
to moveWindows(processesToMove)
	set {screenWidth, screenHeight} to screenSize
	tell application "System Events"
		repeat with procName in processesToMove
			try
				tell process procName
					repeat with win in windows
						set {_x, _y} to position of win
						if (_x < 0 or _y < 0 or _x ≥ defaultDisplay's screenWidth or _y ≥ defaultDisplay's screenHeight) then
							-- TODO move to a relatively similar position as where it was?
							set position of win to defaultDisplay's baseCoords
						end if
					end repeat
				end tell
			end try
		end repeat
	end tell
end moveWindows

# vim:ft=applescript
