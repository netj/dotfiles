#!/usr/bin/env bash
# netj's bash configuration
# Author: Jaeho Shin <netj@sparcs.kaist.ac.kr>
# Created: 2000-10-20
# Reformed: 2004-05-28

# load local settings and modules
for REPLY in ~/.bash/.vocabularies ~/.bash_local ~/.bash/.loader; do
    [ -f $REPLY ] && . $REPLY
done

# vim:et:ts=4:sw=4:sts=4
