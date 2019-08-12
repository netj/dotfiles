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
brew update

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

get dropbox

# get github-desktop
get osxfuse
# get sshfs
get xquartz

# TODO force
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

# Other nice ones ######################

# get gpgtools
# get cleanarchiver
get tnefs-enough
get shrinkit

# get skype
# get teamviewer

# get adium
get firefox
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
get appfresh
# get grandperspective  # using DaisyDisk from AppStore
get omnidisksweeper

# get fantastical

get macid
# get knock
get language-switcher

get transmission
# get cyberduck
get dictunifier
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
get wacom-graphire4-tablet
# get yubikey-personalization-gui
# get iphone-backup-extractor
# get phoneclean
# get delicious-library
