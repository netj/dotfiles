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

property defaultDisplay : macbookDisplay

on run args
	
	-- consider the screen size
	tell application "Finder" to ¡þ
		set {_x, _y, _w, _h} to bounds of window of desktop
	
	if (count args) = 0 then
		if _w = item 1 of defaultDisplay's screenSize and _h = item 2 of defaultDisplay's screenSize then
			set args to {"MacBook"}
		else if _w > item 1 of defaultDisplay's screenSize or _h > item 2 of defaultDisplay's screenSize then
			set args to {"Gates Office"}
		end if
	end if
	
	-- move and resize some apps (without knowing the environment)
	if appIsRunning("Safari") then tell application "Safari" to my moveAndResize({w:1321, wins:windows})
	
	-- decide the environment
	if "MacBook" is in args then
		adjustDisplayCoordinatesWithDock(defaultDisplay)
		-- some environment specific move/resizes
		if appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.98, wins:windows})
	else if "Gates Office" is in args then
		-- I have a SyncMaste 305T in my office :)
		set defaultDisplay to syncmaster30inDisplay
		adjustDisplayCoordinatesWithDock(defaultDisplay)
		-- adjust offset of macbookDisplay
		set macbookDisplay's screenMargin to {2, 2}
		set macbookDisplay's baseCoords to {484, 1600}
		-- some environment specific move/resizes
		if appIsRunning("Safari") then tell application "Safari" to my moveAndResize({h:0.8, wins:windows})
	end if
	
	-- move and resize some apps
	
	if appIsRunning("Mail") then tell application "Mail" to my moveAndResize({disp:macbookDisplay, x:0, y:0, w:1532, h:1, wins:windows of message viewers})
	if appIsRunning("iChat") then tell application "iChat" to my moveAndResize({disp:macbookDisplay, x:0.9, y:0.9, h:700, wins:windows})
	if appIsRunning("Twitter") then tell application "Twitter" to my moveAndResize({disp:macbookDisplay, x:1, y:0, h:1, wins:windows})
	
	if appIsRunning("Skim") then tell application "Skim" to my moveAndResize({wins:windows, w:0.6, h:1})
	if appIsRunning("Papers2") then
		tell application "System Events"
			repeat
				-- XXX if Papers is in a different Space, no windows are seen here
				tell application "Papers2" to activate
				key code 37 using command down -- Cmd-L to go to its window
				delay 1
				tell process "Papers2" to set papersWindows to get windows
				if (count papersWindows) > 0 then
					my moveAndResize({x:0, y:0, wins:papersWindows, w:1, h:1})
					exit repeat
				else
					-- if the screen is locked, no papersWindows will be found, so repeat it
					delay 5
				end if
			end repeat
		end tell
	end if
	
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
	if dockX = 0 ¡þ
		then -- dock is at left
		set displayInfo's baseCoords to {dockW, menubarHeight}
		set displayInfo's screenMargin to displayInfo's baseCoords
	else if dockY + dockH ¡Ã item 2 of displayInfo's screenSize ¡þ
		then -- dock is at bottom
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
	-- XXX these try-on-error really sucks :(
	try
		set wins to wins of args
	on error
		set wins to null
	end try
	try
		set displayInfo to disp of args
	on error
		set displayInfo to defaultDisplay
	end try
	try
		set newX to x of args
	on error
		set newX to null
	end try
	try
		set newY to y of args
	on error
		set newY to null
	end try
	try
		set newW to w of args
	on error
		set newW to null
	end try
	try
		set newH to h of args
	on error
		set newH to null
	end try
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
			if newW ¡Â 1 then -- scale
				set _w to newW * effWidth
			else
				set _w to newW
			end if
		end if
		set _h to origH
		if newH is not null then
			if newH ¡Â 1 then
				set _h to newH * effHeight
			else
				set _h to newH
			end if
		end if
		
		-- then, the position
		set _x to origX
		if newX is not null then
			if newX ¡Â 1 then
				set _x to offsetX + newX * (effWidth - _w)
			else
				set _x to newX
			end if
		end if
		set _y to origY
		if newY is not null then
			if newY ¡Â 1 then
				set _y to offsetY + newY * (effHeight - _h)
			else
				set _y to newY
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
						if (_x < 0 or _y < 0 ¡þ
							or _x ¡Ã defaultDisplay's screenWidth ¡þ
							or _y ¡Ã defaultDisplay's screenHeight) then
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
