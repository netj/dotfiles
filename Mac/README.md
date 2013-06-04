Mac Configurations
==================

## Tweak.sh
This shell script includes some preference tweaks I use on my Macs.


## Terminal.app
Open any `.terminal` file to load configuration into Mac OS X's Terminal app.
You should use Mac's default terminal unless you have a strong reason to do
otherwise even after watching [the talk given by Terminal.app's author][Ben Stiglitz's talk].
[TotalTerminal][] is another reason why you should use the default one.  I
recommend using [Envy Code R font][] for your terminal if you want something
different from Apple's default, Menlo or Monaco.  You can find more fonts from
my [.fonts directory](../../../tree/master/.fonts#readme).

### MouseTerm
[MouseTerm][] is a great SIMBL plugin, which passes mouse events to programs
running in Mac OS X's Terminal.app, e.g., tmux, vim, or emacs.  I [highly
recommend installing it](http://superuser.com/a/595284/45702) because there's
nothing to lose.

You can still use most of the old mouse behavior with option key pressed, e.g.,
Option+Command+clicking for opening URLs, selecting blocks of text, etc.
However, selection that spans over multiple lines becomes impossible.  A
workaround is to select all lines from the first column and trim the first and
last line afterwards.


## KeyRemap4MacBook .xml
[KeyRemap4MacBook][] is a great tool that allows you to remap keyboard in OS X.
I'm using it to remap left command as option key except a few Mac key
combinations in Terminal.app, and Esc to switch back to English IM in Vim to
make life easier.


## Many Scripts
In the `Scripts` directory, there are various AppleScripts I use for many
purposes.  I bind them to global and application-specific shortcut keys with
[FastScripts][].  Some might be useful as-is, others might need to be tailored
to fit your need.  Feel free to copy and modify them, or include in your
scripts.

### Automatically Organizing Window Layouts
I'm using `Adapt to Environment.applescript` with [Control Plane][] for
repositioning and resizing windows as I move around.


## BetterTouchToolGestures
[BetterTouchTool][] is another awesome tool that lets me use trackpad on a
whole new level.


## [Change Default Font Fallbacks][MacOSXDefaultFontFallbacksChanger]
`DefaultFontFallbacksChanger` directory contains a `.command` script which
allows you to switch your Mac's default font fallbacks.


[TotalTerminal]: http://totalterminal.binaryage.com 
[Ben Stiglitz's talk]: http://totalterminal.binaryage.com/#special-guest
[Envy Code R font]: http://damieng.com/blog/2008/05/26/envy-code-r-preview-7-coding-font-released
[MouseTerm]: https://bitheap.org/mouseterm/
[KeyRemap4MacBook]: http://pqrs.org/macosx/keyremap4macbook/
[FastScripts]: http://www.red-sweater.com/fastscripts/
[Control Plane]: http://www.controlplaneapp.com/
[BetterTouchTool]: http://blog.boastr.net/
[MacOSXDefaultFontFallbacksChanger]: https://github.com/netj/MacOSXDefaultFontFallbacksChanger
