# AppleScript for setting ScreenSaver's askForPasswordAfter settings on Mountain Lion (Korean locale)
#
# Most of the credit goes to Daniel Beck's original script: http://superuser.com/a/280711/45702
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-10-03

on run args
	try
		set nthOption to first item of args as number
		get nthOption
	on error
		set nthOption to 1
	end try
	tell application "System Preferences"
		set current pane to pane id "com.apple.preference.security"
		tell application "System Events"
			tell process "System Preferences"
				tell first window
					tell first tab group
						# ensure we're on the first tab
						click (first radio button whose title is "일반") -- "General"

						# 'require password' checkbox
						set cb to (first checkbox whose description is "잠자기 또는 화면 보호기 시작 이후에 암호 요구 체크상자") -- "...?"

						# 'require password' popup button
						set pb to pop up button 1

						# always enable password
						if value of cb is not 1 then
							# password is currently disabled, enable it
							click cb
						end if

						# if password is activated now, set the timeout
						# this check is redundant, you can remove it
						if value of cb is 1 then
							# click pop up button to get menu
							click pop up button 1
							# select 'immedately', '5 seconds', ...
							click menu item nthOption of menu of pb
						end if
					end tell
				end tell
			end tell
		end tell
		quit
	end tell
end run
