.PHONY: install uninstall

HOME_FILES = xmobarrc \
						 xsession
INSTALLED_HOME_FILES = $(HOME_FILES:%=$(HOME)/.%)

XMONAD_FILES = xmonad.hs \
							 startup-hook
INSTALLED_XMONAD_FILES = $(XMONAD_FILES:%=$(HOME)/.xmonad/%)

ALL_FILES = $(BIN_FILES) $(HOME_FILES) $(XMONAD_FILES)

CURRENTDIR=$(shell pwd)

install-xmonad: $(XMONAD_FILES)
	mkdir -p $(HOME)/.xmonad
	
	for i in $(XMONAD_FILES); do \
		install $(CURRENTDIR)/$$i $(HOME)/.xmonad/$$i; \
	done; \

install: $(ALL_FILES) install-xmonad
	mkdir -p $(HOME)/bin
	
	# WAAAAH!
	for i in $(HOME_FILES); do \
		install $(CURRENTDIR)/$$i $(HOME)/.$$i; \
	done; \
  for i in $(BIN_FILES); do \
		install $(CURRENTDIR)/$$i $(HOME)/bin/$$i; \
	done


uninstall: $(INSTALLED_XMONAD_FILES) $(INSTALLED_HOME_FILES)
	rm -f $^
