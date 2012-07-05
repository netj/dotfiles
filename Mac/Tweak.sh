#!/usr/bin/env bash
# A script for tweaking various preferences of Mac OS X and apps
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-07-05
# See-Also: http://secrets.blacktree.com/
set -eu

defaults write com.apple.dock mouse-over-hilite-stack -boolean true
defaults write com.apple.dock itunes-notifications -boolean true
defaults write com.apple.dock notification-always-show-image -boolean true
defaults write com.apple.dock mineffect -string Scale

defaults write com.apple.finder QLEnableXRayFolders -boolean true
defaults write com.apple.finder ShowPathBar -boolean true
defaults write com.apple.finder PathBarRootAtHome -boolean true

defaults write -g ApplePressAndHoldEnabled -boolean false
defaults write -g AppleShowAllExtensions -boolean true
defaults write -g NSNavPanelExpandedStateForSaveMode -boolean true

defaults write com.apple.Safari ShowStatusBar -boolean true
defaults write com.apple.Safari WebKitDeveloperExtras -boolean true
defaults write com.apple.Safari WebKitWebGLEnabled -boolean true
defaults write com.apple.Safari IncludeDebugMenu -boolean true

