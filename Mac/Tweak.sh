#!/usr/bin/env bash
# A script for tweaking various preferences of Mac OS X and apps
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-07-05
# See-Also: http://secrets.blacktree.com/
set -eu

defaults write com.apple.dock showhidden -boolean true
defaults write com.apple.dock mouse-over-hilite-stack -boolean true
defaults write com.apple.dock itunes-notifications -boolean true
defaults write com.apple.dock notification-always-show-image -boolean true
defaults write com.apple.dock mineffect -string Scale
# Hot Corners with Cmd+[tb][lr] (inspired by http://macmule.com/2011/03/08/set-start-screen-saver-to-a-hot-corner/)
# domain=com.apple.Dock; for key in wvous-{b,t}{l,r}-{corner,modifier}; do echo defaults write $domain $key $(defaults read $domain $key); done
defaults write com.apple.Dock wvous-bl-corner   10
defaults write com.apple.Dock wvous-bl-modifier 1048576
defaults write com.apple.Dock wvous-br-corner   2
defaults write com.apple.Dock wvous-br-modifier 1048576
defaults write com.apple.Dock wvous-tl-corner   5
defaults write com.apple.Dock wvous-tl-modifier 1048576
defaults write com.apple.Dock wvous-tr-corner   7
defaults write com.apple.Dock wvous-tr-modifier 1048576
killall DashboardClient || true
killall Dock

defaults write com.apple.finder QLEnableXRayFolders -boolean true
defaults write com.apple.finder ShowPathBar -boolean true
defaults write com.apple.finder PathBarRootAtHome -boolean true
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
killall Finder

defaults write -g ApplePressAndHoldEnabled -boolean false
defaults write -g AppleShowAllExtensions -boolean true
defaults write -g NSNavPanelExpandedStateForSaveMode -boolean true
defaults write -g NSScrollAnimationEnabled -bool NO

defaults write com.apple.Safari ShowStatusBar -boolean true
defaults write com.apple.Safari WebKitDeveloperExtras -boolean true
defaults write com.apple.Safari WebKitWebGLEnabled -boolean true
defaults write com.apple.Safari IncludeDebugMenu -boolean true
# http://hints.macworld.com/article.php?story=20120731105734626
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2StandardFontFamily 'Lucida Grande'
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DefaultFontSize 18
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2FixedFontFamily 'Envy Code R'
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DefaultFixedFontSize 16

# How to show Dictionary definitions first in Spotlight results
# See-Also: http://apple.stackexchange.com/a/52530
if ! defaults read com.apple.spotlight orderedItems 2>/dev/null | grep -q MENU_DEFINITION; then
    spotlightPlist=~/Library/Preferences/com.apple.spotlight.plist
    if [ -e $spotlightPlist ]; then
        defaults write com.apple.spotlight orderedItems -array-add '{"enabled"=true;"name"="MENU_DEFINITION";}'
    else
        plutil -convert binary1 -o $spotlightPlist -- - <<<\
'{"version":2'\
',"orderedItems":'\
'[{"enabled":true,"name":"MENU_DEFINITION"}'\
',{"enabled":true,"name":"APPLICATIONS"}'\
',{"enabled":true,"name":"SYSTEM_PREFS"}'\
',{"enabled":true,"name":"DOCUMENTS"}'\
',{"enabled":true,"name":"DIRECTORIES"}'\
',{"enabled":true,"name":"MESSAGES"}'\
',{"enabled":true,"name":"CONTACT"}'\
',{"enabled":true,"name":"EVENT_TODO"}'\
',{"enabled":true,"name":"IMAGES"}'\
',{"enabled":true,"name":"PDF"}'\
',{"enabled":true,"name":"BOOKMARKS"}'\
',{"enabled":true,"name":"MUSIC"}'\
',{"enabled":true,"name":"MOVIES"}'\
',{"enabled":true,"name":"FONTS"}'\
',{"enabled":true,"name":"PRESENTATIONS"}'\
',{"enabled":true,"name":"SPREADSHEETS"}'\
']}'
    fi
    open /System/Library/PreferencePanes/Spotlight.prefPane
fi
