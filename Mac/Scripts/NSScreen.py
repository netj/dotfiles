#!/usr/bin/env python
import sys
from AppKit import *

def usage():
    print """Usage: %(name)s [SCREEN_NUMBER | WIDTHxHEIGHT]... --  ATTRIBUTE...

ATTRIBUTE can be one of:
  X Y W H
  Xvisible Yvisible Wvisible Hvisible
  NSScreenNumber

Example:
  %(name)s 1680x1050 -- X Y W H
""" % {"name": sys.argv[0]}
    sys.exit(1)

if len(sys.argv) < 4:
    usage()

try:
    iDashdash = sys.argv.index("--")
except:
    usage()
displaysInQuestion = sys.argv[1:iDashdash]
attributesInQuestion = sys.argv[iDashdash+1:]

# Hide Dock icon since it will interfere with what we're doing here
# See: http://stackoverflow.com/a/9220911/390044
# See: https://developer.apple.com/library/mac/#documentation/AppKit/Reference/NSRunningApplication_Class/Reference/Reference.html
NSApplicationActivationPolicyRegular = 0
NSApplicationActivationPolicyAccessory = 1
NSApplicationActivationPolicyProhibited = 2
NSApplication.sharedApplication()
NSApp.setActivationPolicy_(NSApplicationActivationPolicyProhibited)

# Get the mainScreen
mf = NSScreen.mainScreen().frame()
mY = mf.origin.y
mH = mf.size.height

# and all screens to process query
screens = NSScreen.screens()
def screenIdOf(screen):
    return str(screen.deviceDescription()["NSScreenNumber"])
def screenDimOf(screen):
    f = screen.frame()
    return "%dx%d" % (f.size.width, f.size.height)

matchedScreens = [s for s in screens if screenIdOf(s) in displaysInQuestion]
if len(matchedScreens) == 0:
    matchedScreens = [s for s in screens if screenDimOf(s) in displaysInQuestion]

for screen in matchedScreens:
    d = dict(screen.deviceDescription())
    f = screen.frame()
    # See: https://github.com/rcmdnk/AppleScript/blob/master/windowSize.applescript
    d["X"] = int(f.origin.x) # - mX)
    d["Y"] = int(mY + mH - (f.origin.y+f.size.height))
    d["W"] = int(f.size.width)
    d["H"] = int(f.size.height)
    vf = screen.visibleFrame()
    d["Xvisible"] = int(vf.origin.x) # - mX)
    d["Yvisible"] = int(mY + mH - (vf.origin.y+vf.size.height))
    d["Wvisible"] = int(vf.size.width)
    d["Hvisible"] = int(vf.size.height)
    for attr in attributesInQuestion:
        print d[attr]
    break
