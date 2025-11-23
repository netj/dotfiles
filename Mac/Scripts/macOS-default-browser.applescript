#!/usr/bin/env osascript
use AppleScript version "2.4" -- Yosemite (10.10) or later
use framework "Foundation"
use scripting additions

set NSWorkspace to a reference to NSWorkspace of current application
set sharedWorkspace to sharedWorkspace() of NSWorkspace
set |NSURL| to a reference to |NSURL| of current application

-- Create a dummy URL to query for the default application
set urlNSString to (current application's NSString)'s stringWithString:"http://"
set testURL to |NSURL|'s URLWithString:urlNSString

-- Get the URL of the application designated to open the testURL
set theAppURL to sharedWorkspace()'s URLForApplicationToOpenURL:testURL

-- Extract the application name from the URL
set defaultBrowserName to (theAppURL's lastPathComponent()'s stringByDeletingPathExtension()) as text

return defaultBrowserName
