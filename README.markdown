netj's dotfiles
===============

How to use (for the first time)
-------------------------------
1. Run `wget -O- http://sparcs.org/~netj/dotfiles/update | bash` to retrieve
   these files into `~/.dotfiles/`.
2. Run `~/.dotfiles/install` and and enter `y` for those you want to install.

Notes
-----
* Having [Git][] installed is recommended.
* You can run `~/.dotfiles/update` later to merge new stuffs here if Git is
  installed.
* Update still works without Git (if you have wget), but your precious
  modifications will be overwritten. :(
* Simply use `cd ~/.dotfiles; git format-patch sparcs/master` to send me your
  modifications if you want to.
* I use a [zlib/libpng style license][]. See [COPYRIGHT](COPYRIGHT) for more
  information about using these files.

[git]: http://git-scm.com/
[zlib/libpng style license]: http://www.opensource.org/licenses/zlib-license.php

Warning
-------
* Use entirely at your own risk -- no warranty is expressed or implied.
* Playing with your dotfiles is a very time consuming activity.


<address>
Comments to Jaeho Shin &lt;netj@sparcs.org>.
</address>
