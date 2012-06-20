# AppleScript for opening selected files with Vim editor
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-10-06

set myFavoriteEditor to application "MacVim"
tell application "Finder" to open selection using path to myFavoriteEditor
