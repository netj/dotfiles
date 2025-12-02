# ~/.zprofile for launching login shells to latest bash from Homebrew on macOS
# Origin: https://gist.github.com/netj/f76dffced1995a10a4c455d8418ed47d
#
# If you still have old bash (3.x) as your shell, please change it to zsh before using this with:
#  chsh -s /bin/zsh

[ "$-" == "${-//[il]/}" ] || # don't interfere when not a login or interactive shell
[ -n "${CLAUDECODE-}" ] ||  # don't interfere with Claude Code
[ -n "${INTELLIJ_ENVIRONMENT_READER-}" ] ||  # don't interfere with PyCharm or IntelliJ IDEs
PATH="/opt/homebrew/bin:$PATH" exec env -u SHELL bash -il
