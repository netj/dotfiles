#!/usr/bin/env bash
# A script for tweaking various preferences of Mac OS X and apps
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-07-05
# See-Also: http://secrets.blacktree.com/
# See-Also: http://osxdaily.com/tag/defaults-write/
# See-Also: https://github.com/mathiasbynens/dotfiles/blob/master/.osx
set -eu

fontSerif='Palatino'
fontSansSerif='Lucida Grande'
fontMonospace='Envy Code R'
#fontMonospace='Ubuntu Mono'

defaults write com.apple.dock showhidden -boolean true
defaults write com.apple.dock mouse-over-hilite-stack -boolean false
defaults write com.apple.dock mineffect -string suck
#defaults write com.apple.dock expose-animation-duration -float 0.17
defaults write com.apple.dock persistent-apps   -array-add '{tile-type="small-spacer-tile";}'
defaults write com.apple.dock persistent-apps   -array-add '{tile-type="small-spacer-tile";}'
defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="small-spacer-tile";}'
killall Dock

defaults write com.apple.finder ShowPathBar -boolean true
defaults write com.apple.finder PathBarRootAtHome -boolean true
defaults write com.apple.finder QLEnableTextSelection -bool true                # Allow text selection in Quick Look
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false      # Disable the warning when changing a file extension
defaults write com.apple.desktopservices DSDontWriteNetworkStores true          # No .DS_Store on network volumes
killall Finder

if [[ -n "$(fc-list "$fontMonospace" 2>/dev/null)" ]]; then
    defaults write org.n8gray.QLColorCode font "$fontMonospace"
    defaults write org.n8gray.QLColorCode fontSizePoints 10
fi
qlmanage -r >/dev/null

# http://brettterpstra.com/2011/12/04/quick-tip-repeat-cocoa-text-actions-emacsvim-style/
defaults write -g NSRepeatCountBinding -string "^u"
defaults write -g NSTextKillRingSize 4
defaults write -g NSTextShowsControlCharacters -bool true

# https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x
# https://github.com/tekezo/Karabiner-Elements/issues/1046
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1
defaults write -g ApplePressAndHoldEnabled -boolean false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g AppleShowAllExtensions -boolean true
defaults write -g AppleMiniaturizeOnDoubleClick -bool false
defaults write -g NSScrollAnimationEnabled -bool false
# defaults write -g NSWindowResizeTime -float 0.001
defaults write -g NSRecentDocumentsLimit 8
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false         # Don't save to iCloud by default
defaults write -g NSNavPanelExpandedStateForSaveMode -boolean true      # Expand save panel by default
defaults write -g PMPrintingExpandedStateForPrint -bool true            # Expand printer panel by default
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# # trackpad configs
# defaults -currentHost write -g com.apple.mouse.tapBehavior 3
# defaults -currentHost write -g com.apple.mouse.swapLeftRightButton -bool false
# defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true
# defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -bool false
# defaults -currentHost write -g com.apple.trackpad.twoFingerDoubleTapGesture -bool true
# defaults -currentHost write -g com.apple.trackpad.scrollBehavior 2
# defaults -currentHost write -g com.apple.trackpad.momentumScroll -bool true
# defaults -currentHost write -g com.apple.trackpad.ignoreTrackpadIfMousePresent -bool false
# defaults -currentHost write -g com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture 3
# defaults -currentHost write -g com.apple.trackpad.pinchGesture -bool true
# defaults -currentHost write -g com.apple.trackpad.rotateGesture -bool true
# defaults -currentHost write -g com.apple.trackpad.threeFingerTapGesture 0
# defaults -currentHost write -g com.apple.trackpad.threeFingerDragGesture -bool false
# defaults -currentHost write -g com.apple.trackpad.threeFingerHorizSwipeGesture 0
# defaults -currentHost write -g com.apple.trackpad.threeFingerVertSwipeGesture 0
# defaults -currentHost write -g com.apple.trackpad.fourFingerHorizSwipeGesture 2
# defaults -currentHost write -g com.apple.trackpad.fourFingerPinchSwipeGesture 2
# defaults -currentHost write -g com.apple.trackpad.fourFingerVertSwipeGesture 2

defaults write com.apple.Safari WebKitDeveloperExtras -boolean true
#defaults write com.apple.Safari WebKitWebGLEnabled -boolean true
defaults write com.apple.Safari IncludeDebugMenu -boolean true
# http://hints.macworld.com/article.php?story=20120731105734626
#defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2StandardFontFamily "$fontSansSerif"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DefaultFontSize 18
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2FixedFontFamily "$fontMonospace"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DefaultFixedFontSize 16

defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false  # Copy email addresses without the names

defaults write com.apple.Terminal SecureKeyboardEntry -bool true
