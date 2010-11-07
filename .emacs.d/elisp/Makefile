# Makefile for downloading .el files
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2010-11-07

.PHONY: all
all: $(shell sed <Makefile -n '/:.*\#\#$$/ s/:.*$$//p')

color-theme.el: ##
	wget -nv -O $@ \
	    http://orimosenzon.com/misc/color-theme.el

markdown-mode.el: ##
	wget -nv -O $@ \
	    http://jblevins.org/projects/markdown-mode/markdown-mode.el
