netj's Bash Modules
===================

Overview
--------
This directory contains netj's bash modules.

Modules here can be loaded by source'ing the `.loader` file from either
your .bashrc or .bash\_profile.  For example,

    # load local settings and modules
    for REPLY in ~/.bash_local ~/.bash/.loader; do
        [ -f $REPLY ] && . $REPLY
    done

Each module is loaded on startup of shell if either
* `bash_autoload=true` is set in the module itself, or
* `${module_name}_enable=true` was set before source'ing `.loader`,
  e.g. in `.bash_local`.


Structure of Module
-------------------
Each module may define the following functions:
* `bash_import`:
  This function is called before any `bash_load` steps are run.  Define
  things here if you want them to be usable by other modules' `bash_load`.
* `bash_load`:
  This function will be the part where you load stuffs of the module.
* `bash_login`:
  This function is only called when it is a login shell after `bash_load`.

A module may set variable `bash_autoload` to `true`, in order to
automatically enable itself.


Module Loader
-------------
`.loader` is the module loader.  It provides several useful commands to
be used within modules.

* `bash_default name value`
* `bash_default_env name value`
* `bash_default_alias alias command`
* `bash_add_unloader command`
* `bash_insert_prompt command`
* `bash_add_prompt command`


----
Created by Jaeho Shin <netj@sparcs.org> at 2005-06-08.
