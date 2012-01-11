# Makefile for vim stuffs
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2010-08-07

VIMBALL := vim +"source %" +q


.PHONY: all
all: $(shell sed <Makefile -n '/:.*\#\#$$/ s/:.*$$//p')


xmledit: xmledit.vba ##
	$(VIMBALL) $<
xmledit.vba:
	wget -nv -NO $@ \
	    http://www.vim.org/scripts/download_script.php?src_id=13387


mkd: syntax/mkd.vim ##
syntax/mkd.vim: vim-markdown.zip
	unzip -o $<
vim-markdown.zip:
	mkdir -p $(@D)
	wget -nv -NO $@ --no-check-certificate \
	    http://plasticboy.com/dox/vim-markdown.zip #https://github.com/plasticboy/vim-markdown/zipball/master


json: syntax/json.vim ##
syntax/json.vim:
	mkdir -p $(@D)
	wget -nv -NO $@ \
	    http://www.vim.org/scripts/download_script.php?src_id=10853

applescript: syntax/applescript.vim ##
syntax/applescript.vim:
	mkdir -p $(@D)
	wget -nv -NO $@ \
	    http://www.vim.org/scripts/download_script.php?src_id=12658

coffee-script: bundle/vim-coffee-script ##
bundle/vim-coffee-script: autoload/pathogen.vim
	mkdir -p $(@D)
	cd $(@D) && git clone git://github.com/kchmck/vim-coffee-script.git || git pull
autoload/pathogen.vim:
	mkdir -p $(@D)
	wget -nv -NO $@ \
	    http://www.vim.org/scripts/download_script.php?src_id=16224

# http://www.vim.org/scripts/script.php?script_id=625
# See: http://www.vi-improved.org/color_sampler_pack/
ColorSamplerPack: plugin/color_sample_pack.vim ##
plugin/color_sample_pack.vim: ColorSamplerPack.zip
	unzip -o $<
	patch -p0 <jellybeans.vim.patch
ColorSamplerPack.zip:
	wget -nv -NO $@ \
	    http://www.vim.org/scripts/download_script.php?src_id=12179

# http://www.vim.org/scripts/script.php?script_id=1488
ScrollColor: plugin/ScrollColor.vim ##
plugin/ScrollColor.vim:
	mkdir -p $(@D)
	wget -nv -NO $@ \
	    http://www.vim.org/scripts/download_script.php?src_id=5966

# Switch color schemes: http://vim.wikia.com/wiki/VimTip341
SwitchColorSchemes: plugin/setcolors.vim ##
plugin/setcolors.vim:
	mkdir -p $(@D)
	wget -nv -NO $@ --no-check-certificate \
	    https://raw.github.com/gist/1432015/setcolors.vim

## http://www.vim.org/scripts/script.php?script_id=2390
#CSApprox: plugin/CSApprox.vim #x#
#plugin/CSApprox.vim: CSApprox.zip
#	unzip -o $<
#CSApprox.zip:
#	wget -nv -NO $@ \
#	    http://www.vim.org/scripts/download_script.php?src_id=10336

# Scala support
# http://www.schmitztech.com/tech/archives/3
Scala: ftdetect/scala.vim indent/scala.vim plugin/31-create-scala.vim syntax/scala.vim ##
%scala.vim:
	mkdir -p $(@D)
	wget -nv -NO $@ --no-check-certificate \
	    https://raw.github.com/scala/scala-dist/master/tool-support/src/vim/$@

