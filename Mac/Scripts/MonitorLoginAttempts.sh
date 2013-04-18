#!/bin/sh
#open ~/.dotfiles/Mac/Scripts/MonitorLoginAttempts.command
osascript -e 'tell application "Terminal" to do script with command "
exec ~/.dotfiles/Mac/Scripts/MonitorLoginAttempts.command
"'
