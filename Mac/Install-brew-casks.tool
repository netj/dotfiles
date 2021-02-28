#!/usr/bin/env bash
# Installs interactively a list of useful macOS packages via Homebrew Cask (http://caskroom.io)
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2016-03-22
##
set -euo pipefail

+() {
    local o=$(exec 2>&1; set -x; : "$@")
    echo >&2 "${o%% : *} ${o#* : }"
    "$@"
}

# first, a shorthand for a fancy, interactive `brew cask install`
CaskSkipList=$(cd "$(dirname "$0")"; echo "$PWD"/skip.brew-casks)
get() {
    local p=$1; shift
    local u=$p
    [[ $# -eq 0 ]] || { u=${1:-$p}; shift; }
    ! grep -qxF "$p" "$CaskSkipList" &>/dev/null || {
        echo "Skipping $p as it's already skipped/excluded."
        return
    }
    ! { grep -qxF "$p" <<<"$CasksInstalled" &>/dev/null || brew ls --casks $p &>/dev/null; } || {
        echo "Skipping $p as it's already installed."
        return
    }
    read -s -n 1 -p "Install or upgrade $p? [y]es, [s]kip/e[x]clude, [N]o, or [q]uit: "
    echo $REPLY
    case $REPLY in
        [yY]) + brew install $u || + brew install -f $u ;;
        [sSxX])
            echo "$p" >>"$CaskSkipList"
            echo "$p skipped.  To undo, run: sed -i~ '/^$p$/d' $CaskSkipList"
            ;;
        [qQ]) + exit 0 ;;
        *) # skip
    esac
}

type brew || ! open https://brew.sh

# taps
+ brew tap homebrew/cask
+ brew tap homebrew/cask-drivers
# updates
+ brew update

CasksInstalled=$(+ brew list | grep cask || true)

# Essential ###########################
get homebrew/cask/thingsmacsandboxhelper  # Things.app
get homebrew/cask/1password
get homebrew/cask/bettertouchtool
get homebrew/cask/karabiner-elements
get homebrew/cask/macvim
# get homebrew/cask/controlplane
# get homebrew/cask/fastscripts
get homebrew/cask/flycut
# get homebrew/cask/flux
# get homebrew/cask/gfxcardstatus
get homebrew/cask/istat-menus
get homebrew/cask/bartender
get homebrew/cask/bitbar
# get homebrew/cask/macid https://github.com/Homebrew/homebrew-cask/raw/b905b5fabf6218f8e740807ca8fd510519cd8b72/Casks/macid.rb

# get homebrew/cask/dropbox

# get homebrew/cask/github-desktop
get homebrew/cask/osxfuse
# get homebrew/cask/sshfs
get homebrew/cask/xquartz

get homebrew/cask/betterzip
get homebrew/cask/provisionql
get homebrew/cask/qlcolorcode
get homebrew/cask/qlmarkdown
get homebrew/cask/qlprettypatch
get homebrew/cask/qlvideo
get homebrew/cask/quicklook-csv
get homebrew/cask/quicklook-json
get homebrew/cask/suspicious-package
get homebrew/cask/webpquicklook

# Other nice ones ######################

# get homebrew/cask/gpgtools
# get homebrew/cask/cleanarchiver
# get homebrew/cask/tnefs-enough
# get homebrew/cask/shrinkit

# get homebrew/cask/skype
# get homebrew/cask/teamviewer

# get homebrew/cask/adium
get homebrew/cask/firefox
get homebrew/cask/google-chrome
get homebrew/cask/opera
# get homebrew/cask/flash

get homebrew/cask/docker
# get homebrew/cask/virtualbox
# get homebrew/cask/vmware-fusion

get homebrew/cask/emacs
get homebrew/cask/intellij-idea
# get homebrew/cask/eclipse-java
# get homebrew/cask/java6
# get homebrew/cask/gephi
# get homebrew/cask/ghc
get homebrew/cask/r
# get homebrew/cask/processing
# get homebrew/cask/dbvisualizer
# get homebrew/cask/postico

get homebrew/cask/skim
# get homebrew/cask/mactex
get homebrew/cask/papers
get homebrew/cask/djview
# get homebrew/cask/adobe-reader

# get homebrew/cask/airfoil
# get homebrew/cask/linein
# get homebrew/cask/fstream
# get homebrew/cask/ffmpegx
# get homebrew/cask/flip4mac
get homebrew/cask/air-video-server-hd
get homebrew/cask/airserver
get homebrew/cask/paparazzi
get homebrew/cask/inkscape
# get homebrew/cask/powerphotos
# get homebrew/cask/google-earth

# Misc. ################################

# get homebrew/cask/alfred
# get homebrew/cask/keycue
# get homebrew/cask/shortcat
# get homebrew/cask/synergy
get homebrew/cask/omnidazzle
get homebrew/cask/bonjour-browser
# get homebrew/cask/key-codes
get homebrew/cask/keyboardcleantool
get homebrew/cask/pixel-check
get homebrew/cask/onyx
#get secrets
# get homebrew/cask/pref-setter
# get homebrew/cask/rcdefaultapp
# get homebrew/cask/launchpad-manager-yosemite
# get homebrew/cask/launchrocket
# get homebrew/cask/appcleaner
#GONE get homebrew/cask/appfresh
# get homebrew/cask/grandperspective  # using DaisyDisk from AppStore
# get homebrew/cask/omnidisksweeper

# get homebrew/cask/fantastical

# get homebrew/cask/knock
# get homebrew/cask/language-switcher

get homebrew/cask/transmission
# get homebrew/cask/cyberduck
# get homebrew/cask/dictunifier
# get homebrew/cask/bitcoin-core
# get homebrew/cask/bittorrent-sync

# get homebrew/cask/mp3gain-express
#get homebrew/cask/perian homebrew/cask/maddthesane-perian
#get homebrew/cask/quicktime-player7
# get homebrew/cask/vlc
# get homebrew/cask/jubler
# get homebrew/cask/wireshark

# get homebrew/cask/snes9x
# get homebrew/cask/boxer
# get homebrew/cask/dosbox
# get homebrew/cask/dolphin
# get homebrew/cask/wjoy

# get homebrew/cask/eyetv
# get homebrew/cask-drivers/wacom-graphire4-tablet https://github.com/Homebrew/homebrew-cask-drivers/raw/52fe6d023de31110957c7a851cfd67f23f27842d/Casks/wacom-graphire4-tablet.rb
# get homebrew/cask/yubikey-personalization-gui
# get homebrew/cask/iphone-backup-extractor
# get homebrew/cask/phoneclean
# get homebrew/cask/delicious-library
