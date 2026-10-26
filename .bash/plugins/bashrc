#!/usr/bin/env bash
# bpm bashrc -- a portable ~/.bashrc that prepares the shell, then loads bpm
#
# Usage: put this single line in ~/.bashrc (and ~/.bash_profile, or symlink it
# to ~/.bashrc), keeping any host-specific settings below it:
#
#     . ~/.bpm/bashrc
#
# bpm.sh only loads the enabled plug-ins.  This takes care of what must happen
# before any of them, so they work the same on macOS as on Linux:
#   - resets PATH with path_helper in nested macOS login shells, which
#     /etc/profile otherwise reorders on top of what plug-ins have set up
#   - loads the system bashrc (/etc/bashrc)
#   - puts Homebrew first on PATH if installed (/opt/homebrew, /usr/local,
#     or /home/linuxbrew/.linuxbrew)
#   - switches login shells from an old bash 3.x (the GPLv2 one macOS ships)
#     to a newer one on PATH, e.g., Homebrew's
#   - corrects $BASH when a login shell sets it to the user's login shell
#     (e.g., /bin/zsh) instead of bash, which happens when zsh hands over to
#     bash with `exec -l bash`
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2026-10-25
################################################################################

if [ -n "${BASH_VERSION:-}" ]; then  # do nothing when sourced by other shells

case $OSTYPE in darwin*)
    # nested login shells rerun path_helper (via /etc/profile), which moves
    # system paths ahead of the ones plug-ins prepend, so start from a clean slate
    ! shopt -q login_shell || eval "$(env -i /usr/libexec/path_helper -s)"
esac

# load the system bashrc
! [ -r /etc/bashrc ] || . /etc/bashrc

# ensure Homebrew takes precedence when installed
__bpm_brew=$(type -P brew) ||
    for __bpm_brew in "${HOMEBREW_PREFIX:-/opt/homebrew}"/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
    do [[ ! -x "$__bpm_brew" ]] || break
    done
[[ ! -x "$__bpm_brew" ]] || eval "$("$__bpm_brew" shellenv)"

# prefer a newer bash >= 4 on PATH over an old one for login shells,
# preserving the invocation options
if [[ $0 = -* ]] && shopt -q login_shell && [[ ${BASH_VERSINFO[0]} -lt 4 ]] &&
    __bpm_bash=$(type -P bash) &&
    [[ $("$__bpm_bash" -c 'echo ${BASH_VERSINFO[0]}' 2>/dev/null) -ge 4 ]]; then
    SHELL=$__bpm_bash exec -l "$__bpm_bash" -l${-//[chimBH]/}
fi

# a login shell started as `-bash` (no path) takes $BASH from the user's login
# shell, e.g., /bin/zsh, confusing anything that relies on it, including bpm
if [[ $BASH != */bash ]]; then
    if [[ $SHELL = */bash ]]; then BASH=$SHELL; else BASH=$(type -P bash); fi
fi

unset __bpm_brew __bpm_bash

# finally, load bpm
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd -P)"/bpm.sh

fi
