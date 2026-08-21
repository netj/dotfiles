# ~/.zprofile for launching login shells to latest bash from Homebrew on macOS
# Origin: https://gist.github.com/netj/f76dffced1995a10a4c455d8418ed47d
#
# If you still have old bash (3.x) as your shell, please change it to zsh before using this with:
#  chsh -s /bin/zsh

source ~/.zshenv

_switch_to_bash() { exec env SHELL=$(which bash) bash -il; }
[ "$-" = "${-//[il]/}" ] || # don't interfere when not a login or interactive shell
case "${TERM_PROGRAM-${TERMINAL_EMULATOR-}}---${__CFBundleIdentifier-}" in
    # to switch to bash only for known terminals, uncomment below
    # # truly end-user interactive terminals
    # tmux---*) _switch_to_bash ;;
    # Apple_Terminal---com.apple.Terminal) _switch_to_bash ;;
    # Apple_Terminal---com.apple.Terminal) ;;
    # ghostty---*) ;;
    # # not ones running inside AI agents or IDEs
    # *---com.jetbrains.pycharm) ;;
    # zed---*) ;;
    # ---dev.zed.Zed) ;;
    # *) ;;

    ---*) ;;               # unspecified terminal program, likely non-interactive probes (e.g., Zed)
    *) _switch_to_bash ;;  # defaults to switching any interactive login shell to bash
esac
