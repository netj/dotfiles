#!/usr/bin/env osascript
# AppleScript that toggles the "Use all F1, F2, etc. keys as standard function keys" System Preferences option
#
# This is mainly needed by ControlPlane to fiddle with the option upon plugging external keyboard
# because Karabiner Elements for macOS 10.12 does not play nice with the solutions below (esp. Fluor.app),
# but provides an essential function of combining modifier key events from multiple keyboards
# (e.g., my HHKB as well as builtin MacBook Pro keyboard). It inadvertently prevents external keyboards
# from entering any of the standard function keys (F1, F2, ...) when I still want to keep the option checked off
# while using MacBook Pro keyboard alone. Such external keyboards provide no way to trigger Mac's fn key
# unless some key is sacrificed, so it's better to toggle the option when another primary keyboard is connected,
# which is easily done by ControlPlane.
#
# See: https://apple.stackexchange.com/questions/59178/toggle-use-all-f1-f2-as-standard-keys-via-script
# See: https://github.com/Pyroh/Fluor
# See: https://github.com/jakubroztocil/macos-fn-toggle
# See: https://github.com/nelsonjchen/fntoggle/releases

tell application "System Events"
    set wasRunning to count(processes whose name is "System Preferences")
end tell

tell application "System Preferences"
    reveal anchor "keyboardTab" of pane "com.apple.preference.keyboard"
    delay 1
end tell
tell application "System Events" to tell process "System Preferences"
    click checkbox 1 of tab group 1 of window 1
end tell

if wasRunning = 0 then
    quit application "System Preferences"
end if
