#!/usr/bin/env bash
# Installs essential Homebrew (https://brew.sh) packages
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2019-08-12
##
set -eu
set -x

type brew || ! open https://brew.sh

cd "$(dirname "$0")"
brew bundle
