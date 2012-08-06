# AppleScript for starting the screen saver
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2012-06-19
# See: https://discussions.apple.com/thread/1049637?start=0&tstart=0

delay 1
tell application "/System/Library/Frameworks/ScreenSaver.framework/Versions/Current/Resources/ScreenSaverEngine.app" to activate
