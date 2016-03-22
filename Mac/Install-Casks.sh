#!/usr/bin/env bash
# A list of useful OS X packages from Homebrew Cask (http://caskroom.io)

# first, a shorthand for an interactive `brew cask install`
get() {
    local p=
    for p; do
        ! brew cask ls $p &>/dev/null || {
            echo "Skipping $p as it's already installed."
            continue
        }
        read -s -n 1 -p "Install or upgrade $p? [y]es, [N]o, or [q]uit: "
        echo $REPLY
        case $REPLY in
            [yY]) brew cask install $p ;;
            [qQ]) exit 0 ;;
            *) # skip
        esac
    done
}

# taps
brew tap caskroom/versions
# updates
brew cask update

# Essential ###########################
get bartender
get bettertouchtool
get controlplane
get fastscripts
get flux
get gfxcardstatus
get istat-menus
get karabiner
get macid
get knock
get language-switcher

get macvim
get github-desktop
get osxfuse
get sshfs
get xquartz

get betterzipql
get provisionql
get qlcolorcode
get qlmarkdown
get qlprettypatch
get qlvideo
get quicklook-csv
get quicklook-json
get suspicious-package
get webpquicklook

get gpgtools
get cleanarchiver
get tnefs-enough
get shrinkit

# Other nice ones ######################

get mactex
get papers
get djview
get adobe-reader

get skype
get teamviewer

get adium
get firefox
get opera
get flash

get airfoil
get linein
get fstream
get ffmpegx
get flip4mac
get air-video-server-hd
get paparazzi
get inkscape
get powerphotos
get google-earth

get alfred
get keycue
get shortcat
get synergy
get omnidazzle
get bonjour-browser
get key-codes
get keyboardcleantool
get pixel-check
get onyx
#get secrets
get pref-setter
get rcdefaultapp
get launchpad-manager-yosemite
get launchrocket
get appcleaner
get appfresh
get grandperspective
get omnidisksweeper

get virtualbox
get vmware-fusion

get emacs
get eclipse-java
get java6

get graphviz
get gephi
get ghc
get r
get processing
get dbvisualizer

# Misc. ################################

get transmission
get cyberduck
get dictunifier
get bitcoin-core
get bittorrent-sync

get mp3gain-express
#get perian maddthesane-perian
#get quicktime-player7
get vlc
get jubler
get wireshark

get boxer
get dolphin
get dosbox
get snes9x
get wjoy

get eyetv
get wacom-graphire4-tablet
get yubikey-personalization-gui
get iphone-backup-extractor
get phoneclean
get delicious-library
