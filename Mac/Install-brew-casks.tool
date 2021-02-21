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
    ! { grep -qxF "$p" <<<"$CasksInstalled" &>/dev/null || brew cask ls $p &>/dev/null; } || {
        echo "Skipping $p as it's already installed."
        return
    }
    read -s -n 1 -p "Install or upgrade $p? [y]es, [s]kip/e[x]clude, [N]o, or [q]uit: "
    echo $REPLY
    case $REPLY in
        [yY]) + brew cask install $u || + brew cask install -f $u ;;
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
+ brew tap caskroom/cask
+ brew tap caskroom/cask-drivers
+ brew tap caskroom/versions
# updates
+ brew update

CasksInstalled=$(+ brew cask list)

# Essential ###########################
get thingsmacsandboxhelper  # Things.app
get 1password
get bettertouchtool
get karabiner-elements
get macvim
# get controlplane
get fastscripts
get flycut
# get flux
# get gfxcardstatus
get istat-menus
get bartender
get bitbar
get macid https://github.com/Homebrew/homebrew-cask/raw/b905b5fabf6218f8e740807ca8fd510519cd8b72/Casks/macid.rb

get dropbox

# get github-desktop
get osxfuse
# get sshfs
get xquartz

get betterzip
get provisionql
get qlcolorcode
get qlmarkdown
get qlprettypatch
get qlvideo
get quicklook-csv
get quicklook-json
get suspicious-package
get webpquicklook

# Other nice ones ######################

# get gpgtools
# get cleanarchiver
get tnefs-enough
get shrinkit

# get skype
# get teamviewer

# get adium
get firefox
get google-chrome
get opera
# get flash

get docker
get virtualbox
get vmware-fusion

get emacs
get intellij-idea
# get eclipse-java
# get java6
# get gephi
# get ghc
get r
# get processing
# get dbvisualizer
get postico

get skim
get mactex
get papers
get djview
# get adobe-reader

# get airfoil
# get linein
# get fstream
# get ffmpegx
# get flip4mac
get air-video-server-hd
get airserver
get paparazzi
get inkscape
get powerphotos
# get google-earth

# Misc. ################################

# get alfred
# get keycue
# get shortcat
# get synergy
get omnidazzle
get bonjour-browser
get key-codes
get keyboardcleantool
get pixel-check
get onyx
#get secrets
get pref-setter
get rcdefaultapp
# get launchpad-manager-yosemite
get launchrocket
get appcleaner
#GONE get appfresh
# get grandperspective  # using DaisyDisk from AppStore
# get omnidisksweeper

# get fantastical

# get knock
get language-switcher

get transmission
# get cyberduck
# get dictunifier
# get bitcoin-core
# get bittorrent-sync

# get mp3gain-express
#get perian maddthesane-perian
#get quicktime-player7
get vlc
# get jubler
# get wireshark

get snes9x
# get boxer
# get dosbox
# get dolphin
# get wjoy

get eyetv
get wacom-graphire4-tablet https://github.com/Homebrew/homebrew-cask-drivers/raw/52fe6d023de31110957c7a851cfd67f23f27842d/Casks/wacom-graphire4-tablet.rb
# get yubikey-personalization-gui
# get iphone-backup-extractor
# get phoneclean
# get delicious-library