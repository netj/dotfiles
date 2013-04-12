# [Factorized SSH Config Manager](http://github.com/netj/dotfiles/tree/master/.ssh)

[OpenSSH][] doesn't let your `~/.ssh/config` include other files, so you can't split it into multiple files.
This becomes a problem as your ssh config grows complicated and varies by host, but you still want to reuse some parts of it.
To overcome this headache, [netj][] wrote a small Makefile.
With this Makefile you can manage your complex ssh config into small separate files, called *config blocks*, and easily generate the actual config file from them.
You can easily enable or disable individual config blocks, so only the desired ones are included in the generated config.
All you need to do to create a new config block is to save the lines you want to include in your `~/.ssh/config` as a new file under `~/.ssh/config.d/`.

Enjoy!


## Usage

* To generate your ssh_config(5) file from enabled ones:

        make config

* To enable all config blocks:

        make enable

* Or, to just enable `NAME` individually:

        make enable C=NAME

* To disable all config blocks:

        make disable

* Or, to just disable `NAME` individually:

        make disable C=NAME


## See Also
* [superuser Q&A: "Is there a way for one SSH config file to include another one?"](http://superuser.com/questions/247564/is-there-a-way-for-one-ssh-config-file-to-include-another-one).
* ssh_config(5) man page.


[netj]: http://github.com/netj
[openssh]: http://openssh.org
