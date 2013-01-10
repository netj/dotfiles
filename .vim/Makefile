# Makefile for Vim stuffs (not covered by VAM aka vim-addon-manager)
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2010-08-07

.PHONY: all
all: $(shell sed <Makefile -n '/:.*\#\#$$/ s/:.*$$//p')

# VAM installation
vam-update: ##
	vim -u NONE \
	    +"set nomore | source ~/.vim/addons.vim" \
	    +"set nomore | UpdateAddons vim-addon-manager-known-repositories" \
	    +"set nomore | UpdateActivatedAddons" \
	    +"qa" \
	    #
	vim -u NONE \
	    ~/.bash_local + \
	    +"g/^## vim with addons {{{$$/,/^## }}}$$/d" \
	    +"let o='O' | if line('.')==line('$$') | let o='o'" \
	    +"exec 'norm '.o.'## vim with addons {{{'" \
	    +'r!sed -n '\''/".*add.*alias.*>$$/,/^"<$$/{/^"   /s/^" *//p}'\'' <~/.vimrc' \
	    +"norm o## }}}" \
	    +wq \
	    #

# I like jellybeans but need to tweak a little
patch-Color_Sampler_Pack-jellybeans: jellybeans.vim.patch vam-update ##
	-cd vim-addons/Colour_Sampler_Pack && patch -fp0 <../../$<

# CoffeeTags + TagBar + Vim
# See: https://github.com/lukaszkorecki/CoffeeTags#readme
coffeetags: ##
	! type coffeetags || { \
	    mkdir -p ftplugin/coffee && \
	    coffeetags --vim-conf >ftplugin/coffee/tagbar-coffee.vim; \
	}

