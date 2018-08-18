bpm -- Bash Plug-in Manager
===========================

bpm is a plug-in manager for [bash][].  You can use it to manage your bash
configuration in a modular fashion, and easily share parts of it with others.
It manages dependencies and does other cool stuff.

[bash]: http://www.gnu.org/software/bash/ "GNU Bourne-Again SHell"


Installation
------------

1. Get [the code](https://github.com/netj/bpm):

        git clone https://github.com/netj/bpm.git ~/.bpm

2. Add following line to your `~/.bashrc` and `~/.bash_profile`:

        . ~/.bpm/bpm.sh load

3. To use `bpm` command, run the line above with your current shell or start a
   new one.


Usage
-----

Once installed, `bpm` command is your friend.

All available plug-ins are shown by

    bpm find

More information about particular plug-in, say `foo`, is shown by

    bpm info foo

To enable a plug-in, run:

    bpm enable foo

To disable it:

    bpm disable foo

You can use `bpm on` and `bpm off` instead if you prefer shorter ones.

All enabled plug-ins are shown by

    bpm ls


And that's almost everything about using bpm.  Enjoy!

~[netj][]

[netj]: https://github.com/netj
