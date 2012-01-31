# Makefile for Vim stuffs (not covered by VAM aka vim-addon-manager)
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2010-08-07

.PHONY: all
all: $(shell sed <Makefile -n '/:.*\#\#$$/ s/:.*$$//p')

# I like jellybeans but need to tweak a little
patch-Color_Sampler_Pack-jellybeans: jellybeans.vim.patch ##
	vim +q
	-cd vim-addons/Color_Sampler_Pack && patch -fp0 <../../$<

# Switch color schemes: http://vim.wikia.com/wiki/VimTip341
SwitchColorSchemes: plugin/setcolors.vim ##
plugin/setcolors.vim:
	mkdir -p $(@D)
	curl -#LRko $@ https://raw.github.com/gist/1432015/setcolors.vim

