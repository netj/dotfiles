# Makefile for netj's dotfiles
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2009-02-12

.PHONY: INDEX
INDEX:
	find . \( -name .git -o -name _darcs \) -prune -false \
	    -o -type f ! -name .gitignore ! -name \*.sw? | \
	    sed 's:^\./::' | \
	    sort >$@ 

HEADER.html: README
	bood <$< >$@


# TODO: rewrite in Make
install:
	./install

update:
	./update

