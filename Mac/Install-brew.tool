#!/usr/bin/env bash
# Installs essential Homebrew (https://brew.sh) packages
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2019-08-12
##
set -eu

type brew || ! open https://brew.sh
set -x

ensure_brew_installs() {
    : ${brew_flags:=}
    brew upgrade -f $brew_flags "$@" ||
    brew install    $brew_flags "$@" ||
    # XXX brew install -f "$@"  literally reinstalls everything even though it's already installed, so falling back to a significantly slower loop that checks every package
    for pkg; do
        brew install    $brew_flags "$pkg" ||
        brew install -f $brew_flags "$pkg"
    done
}

brew_pkgs=(
    ant
    arping
    autossh
    awscli
    bash
    bash-completion2
    bats
    black
    pre-commit
    clang-format
    ctags
    coreutils
    debianutils
    diff-so-fancy
    docker-completion
    #docker-compose-completion
    ffmpeg
    # cabal-install
    # ghc
    # haskell-stack
    git  # NOTE as of macOS 15 git-completion can be installed via: ln -sfnv /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash /opt/homebrew/etc/bash_completion.d/
    git-gui
    git-extras
    git-subrepo
    gnuplot
    go
    graphviz
    #homebrew/cask/adoptopenjdk
    #homebrew/cask/brightness
    #homebrew/cask/cmake
    homebrew/cask/lynx
    htop-osx
    fzf
    gh
    hunspell
    jq
    lftp
    lz4
    lzip
    markdown
    maven
    mercurial
    mobile-shell
    moreutils
    mutt
    netcat
    netj/tap/remocon
    netpbm
    nmap
    node
    octave
    osxutils
    p7zip
    pbzip2
    pdf2svg
    pstree
    pv
    # pypy
    python3
    uv
    ruff
    reattach-to-user-namespace
    rename
    rlwrap
    rrdtool
    rsync
    scons
    sloccount
    socat
    ssh-copy-id
    theseal/ssh-askpass/ssh-askpass
    tmux
    unzip
    vim
    wget
    xml-coreutils
    xmlstarlet
    xz
    youtube-dl


    # Essential ###########################
    homebrew/cask/thingsmacsandboxhelper  # Things.app
    homebrew/cask/1password
    homebrew/cask/bettertouchtool
    homebrew/cask/karabiner-elements
    homebrew/cask/macvim
    # homebrew/cask/controlplane
    # homebrew/cask/fastscripts
    homebrew/cask/flycut
    # homebrew/cask/flux
    # homebrew/cask/gfxcardstatus
    homebrew/cask/istat-menus
    homebrew/cask/ice
    homebrew/cask/xbar
    homebrew/cask/soundsource
    # homebrew/cask/macid https://github.com/Homebrew/homebrew-cask/raw/b905b5fabf6218f8e740807ca8fd510519cd8b72/Casks/macid.rb

    # homebrew/cask/dropbox

    # homebrew/cask/github-desktop
    homebrew/cask/macfuse
    # homebrew/cask/osxfuse  # XXX no longer for M1 Macs
    # homebrew/cask/sshfs
    homebrew/cask/xquartz

    homebrew/cask/betterzip
    homebrew/cask/provisionql
    homebrew/cask/qlcolorcode
    homebrew/cask/qlmarkdown
    homebrew/cask/qlprettypatch
    homebrew/cask/qlvideo
    homebrew/cask/quicklook-csv
    homebrew/cask/quicklook-json
    homebrew/cask/suspicious-package
    homebrew/cask/webpquicklook

    # Other nice ones ######################

    # homebrew/cask/gpgtools
    # homebrew/cask/cleanarchiver
    # homebrew/cask/tnefs-enough
    # homebrew/cask/shrinkit

    # homebrew/cask/skype
    # homebrew/cask/teamviewer

    # homebrew/cask/adium
    homebrew/cask/firefox
    homebrew/cask/google-chrome
    homebrew/cask/opera
    # homebrew/cask/flash

    homebrew/cask/docker
    # homebrew/cask/virtualbox
    # homebrew/cask/vmware-fusion

    # homebrew/cask/emacs
    homebrew/cask/pycharm
    #homebrew/cask/intellij-idea
    # homebrew/cask/eclipse-java
    # homebrew/cask/java6
    # homebrew/cask/gephi
    # homebrew/cask/ghc
    # homebrew/cask/r
    # homebrew/cask/processing
    # homebrew/cask/dbvisualizer
    # homebrew/cask/postico

    homebrew/cask/skim
    # homebrew/cask/mactex
    homebrew/cask/papers
    # homebrew/cask/djview
    # homebrew/cask/adobe-reader

    # homebrew/cask/airfoil
    # homebrew/cask/linein
    # homebrew/cask/fstream
    # homebrew/cask/ffmpegx
    # homebrew/cask/flip4mac
    homebrew/cask/air-video-server-hd
    homebrew/cask/airserver
    homebrew/cask/paparazzi
    homebrew/cask/inkscape
    # homebrew/cask/powerphotos
    # homebrew/cask/google-earth

    # Misc. ################################

    # homebrew/cask/alfred
    # homebrew/cask/keycue
    # homebrew/cask/shortcat
    # homebrew/cask/synergy
    homebrew/cask/omnidazzle
    # homebrew/cask/bonjour-browser
    # homebrew/cask/key-codes
    homebrew/cask/keyboardcleantool
    homebrew/cask/pixel-check
    homebrew/cask/onyx
    #homebrew/cask/secrets
    # homebrew/cask/pref-setter
    # homebrew/cask/rcdefaultapp
    # homebrew/cask/launchpad-manager-yosemite
    # homebrew/cask/launchrocket
    # homebrew/cask/appcleaner
    #GONE homebrew/cask/appfresh
    # homebrew/cask/grandperspective  # using DaisyDisk from AppStore
    # homebrew/cask/omnidisksweeper

    # homebrew/cask/fantastical

    # homebrew/cask/knock
    # homebrew/cask/language-switcher

    # homebrew/cask/transmission
    # homebrew/cask/cyberduck
    # homebrew/cask/dictunifier
    # homebrew/cask/bitcoin-core
    # homebrew/cask/bittorrent-sync

    # homebrew/cask/mp3gain-express
    #homebrew/cask/perian homebrew/cask/maddthesane-perian
    #homebrew/cask/quicktime-player7
    # homebrew/cask/vlc
    # homebrew/cask/jubler
    # homebrew/cask/wireshark

    # homebrew/cask/snes9x
    # homebrew/cask/boxer
    # homebrew/cask/dosbox
    # homebrew/cask/dolphin
    # homebrew/cask/wjoy

    # homebrew/cask/eyetv
    # homebrew/cask-drivers/wacom-graphire4-tablet https://github.com/Homebrew/homebrew-cask-drivers/raw/52fe6d023de31110957c7a851cfd67f23f27842d/Casks/wacom-graphire4-tablet.rb
    # homebrew/cask/yubikey-personalization-gui
    # homebrew/cask/iphone-backup-extractor
    # homebrew/cask/phoneclean
    # homebrew/cask/delicious-library

    # vim Edit Popup https://github.com/tonisives/ovim
    neovim
    Alacritty
    tonisives/tap/ovim
)
# TODO skip.brew support
ensure_brew_installs "${brew_pkgs[@]}"

brew_pkgs_HEAD=(
    universal-ctags/universal-ctags/universal-ctags 
)
brew_flags='--fetch-HEAD' \
ensure_brew_installs "${brew_pkgs_HEAD[@]}"

xattr -dr com.apple.quarantine "/Applications/Alacritty.app"
