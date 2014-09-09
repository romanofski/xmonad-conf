.PHONY: install uninstall

BIN_FILES = uvmeter \
						workbalance
INSTALLED_BIN_FILES = $(BIN_FILES:%=$(HOME)/bin/%)

HOME_FILES = xmobarrc \
						 xsession
INSTALLED_HOME_FILES = $(HOME_FILES:%=$(HOME)/.%)

XMONAD_FILES = xmonad.hs \
							 startup-hook
INSTALLED_XMONAD_FILES = $(XMONAD_FILES:%=$(HOME)/.xmonad/%)

ALL_FILES = $(BIN_FILES) $(HOME_FILES) $(XMONAD_FILES)

CURRENTDIR=$(shell pwd)


install: $(ALL_FILES)
	mkdir -p $(HOME)/bin
	mkdir -p $(HOME)/.xmonad
	
	# WAAAAH!
	for i in $(HOME_FILES); do \
		install $(CURRENTDIR)/$$i $(HOME)/.$$i; \
	done; \
  for i in $(XMONAD_FILES); do \
		install $(CURRENTDIR)/$$i $(HOME)/.xmonad/$$i; \
	done; \
  for i in $(BIN_FILES); do \
		install $(CURRENTDIR)/$$i $(HOME)/bin/$$i; \
	done


uninstall: $(INSTALLED_BIN_FILES) $(INSTALLED_XMONAD_FILES) $(INSTALLED_HOME_FILES)
	rm -f $^
