netj's dotfiles
===============

Installation
------------
Run the following command and press `y` for the files you want to install:

    bash <(curl -fsSL git.io/netj.files)

It clones [the git repo][my repo] to `~/.dotfiles`, installs chosen dotfiles as symlinks pointing inside the repo, then runs a new login shell.
Existing dotfiles will be backed up with names ending with `~`.
Make sure you have [Git][] and [curl][] on your system.
You could use `wget -nv -O-` instead of `curl -fsSL` if you have [Wget][].

### Trying out
If you want to simply explore what my dotfiles do, setting a temporary path for `HOME` does the job:

    HOME=/tmp/home  bash <(curl -fsSL git.io/netj.files)



Notes
-----
* There are more good stuffs under [Fonts/](https://github.com/netj/dotfiles/tree/master/Fonts#readme) and [Mac/](https://github.com/netj/dotfiles/tree/master/Mac#readme).

* Put any of your per-machine/per-account tweaks in a `.*_local` file.  For example,

    * `.bash_local` for declaring aliases, adjusting `PATH`, or exporting environment variables.
    * `.vim_local` for any local Vim configuration customization.
    * `.tmux_local` for any local TMUX tweaks, e.g., wrapping the default-command with `reattach-to-user-namespace` in OS X.

* You can run following commands later to stay up-to-date:

        cd ~/.dotfiles
        git pull
        ./install

* If you want to send me your modifications, please put them up in [your GitHub fork](https://github.com/netj/dotfiles/fork) and send me a pull request at [my repo][].

* I use a [zlib/libpng style license][license].
  Consult the `COPYRIGHT` file for more information on using these files.

[my repo]: https://github.com/netj/dotfiles
[git]: http://git-scm.com/
[curl]: http://curl.haxx.se/
[wget]: http://www.gnu.org/software/wget/
[license]: http://www.opensource.org/licenses/zlib-license.php


Warning
-------
* Use entirely at your own risk -- no warranty is expressed or implied.
* Playing around with your dotfiles is a very time consuming activity.


----

~[netj](https://github.com/netj)
