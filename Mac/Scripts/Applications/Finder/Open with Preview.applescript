# AppleScript for opening selected files with Preview
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2016-08-12

tell application "Finder" to open selection using path to application "Preview"
