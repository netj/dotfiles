# Makefile for ssh config
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2013-04-10

ifneq ($(shell cd "$(PWD)" && pwd -P),$(shell pwd -P))
    M = " -C $(shell pwd)"
else
    M =
endif

help:
	@echo "Factorized ssh_config (http://github.com/netj/dotfiles/tree/master/.ssh)"
	@echo "Usage:"
	@echo "  make$(M) help     # to see this help"
	@echo "  make$(M) config   # to generate ssh_config(5) file from enabled ones"
	@echo
	@echo "  make$(M) enable   # to enable all config blocks, or individually:"
	@cd config.d && for c in *; do \
	 ! [ $$c -ef ../config.enabled/$$c ] || continue; \
	 echo "  make$(M) enable C='$$c'"; \
	 done
	@echo
	@echo "  make$(M) disable  # to disable all config blocks, or individually:"
	@cd config.enabled && for c in *; do \
	 echo "  make$(M) disable C='$$c'"; \
	 done

config: Makefile config.enabled config.enabled/*
	# Generating ~/.ssh/config
	@ \
{ \
  echo "# Factorized ssh config"; \
  echo "# Generated: $$(date +%FT%T%:z)"; \
  echo; \
  cat $(filter-out Makefile config.enabled,$^) | \
  grep -v '^#[[:space:]]*vim:'; \
} >$@.tmp; [ -e $@ ] && mv -f $@ $@~; mv -f $@.tmp $@


C ?= *

enable: $(C:%=config.d/%)
	# enabling $(^F)
	@mkdir -pv config.enabled
	@for c in $^; do ln -sfnv ../$$c config.enabled/$${c##*/}; done
	@find config.enabled/ -type l -exec test ! -e {} \; -exec rm -fv {} +

disable: $(C:%=config.enabled/%)
	# disabling $(^F)
	rm -fv $^

.PHONY: help enable disable
