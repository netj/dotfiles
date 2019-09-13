#!/usr/bin/env bash
# Installs essential Homebrew (https://brew.sh) packages
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2019-08-12
##
set -eu

type brew || ! open https://brew.sh

brew_cask_pkgs=(
    adoptopenjdk
    osxfuse
)
brew cask install "${brew_cask_pkgs[@]}"

brew_pkgs=(
    ant
    arping
    autossh
    awscli
    bash
    bash-completion2
    bats
    brightness
    cabal-install
    clang-format
    cmake
    coreutils
    debianutils
    diff-so-fancy
    docker-completion
    ffmpeg
    ghc
    git
    git-extras
    git-subrepo
    gnuplot
    go
    graphviz
    haskell-stack
    htop-osx
    hub
    hunspell
    jq
    lftp
    lynx
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
    pbzip2
    pdf2svg
    pstree
    pv
    pypy
    python3
    reattach-to-user-namespace
    rename
    rlwrap
    rrdtool
    rsync
    scons
    sloccount
    socat
    ssh-copy-id
    sshfs
    tmux
    unrar
    unzip
    vim
    wget
    xml-coreutils
    xmlstarlet
    xz
    youtube-dl
)
brew install "${brew_pkgs[@]}" ||
brew upgrade "${brew_pkgs[@]}"

brew_pkgs_HEAD=(
    universal-ctags/universal-ctags/universal-ctags 
)
brew install --HEAD "${brew_pkgs_HEAD[@]}" ||
brew upgrade --HEAD "${brew_pkgs_HEAD[@]}"
