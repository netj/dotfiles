# AppleScript for opening a new Terminal window
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-10-02

-- TODO need to find command for just locking the screen

-- lock session and show switch user login window
do shell script "/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend"

