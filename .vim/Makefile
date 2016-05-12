# Makefile for Vim stuffs (not covered by VAM aka vim-addon-manager)
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2010-08-07

export SHELL := $(shell which bash)

.PHONY: all
all: $(shell sed <Makefile -n '/:.*\#\#$$/ s/:.*$$//p')

# vundle installation
vundle-update: ##
	read -p "update .vim/bundle/? [yN] " -n1 -t2 || echo n; \
	case $$REPLY in [yY]) echo "updating .vim/bundle/..." ;; *) exit 0 ;; esac; \
	vim +PluginInstall +qa

# tpope's spelling fixes using :Abolish
tpopes-abbrevs: after/plugin/abolish_tpope.vim ##
after/plugin/abolish_tpope.vim:
	mkdir -p $(@D) && cd $(@D) && \
	curl -kRLO https://github.com/tpope/tpope/raw/master/.vim/$@

# Set Skim's SyncTeX settings to MacVim
synctex.skim-macvim: ##
ifeq ($(shell uname),Darwin)
	if mvim=`type -p mvim 2>/dev/null`; then \
    defaults write net.sourceforge.skim-app.skim SKTeXEditorCommand "$(shell pwd)/synctex.skim-macvim.sh"; \
    defaults write net.sourceforge.skim-app.skim SKTeXEditorArguments '"\"%file\" %line \"'"$$mvim"'\""'; \
fi
else
	@# no-op
endif
