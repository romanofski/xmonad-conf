.PHONY: install uninstall

HOME_FILES = xmobarrc \
						 xsession \
						 Xresources
INSTALLED_HOME_FILES = $(HOME_FILES:%=$(HOME)/.%)

XMONAD_FILES = xmonad.hs \
							 startup-hook
INSTALLED_XMONAD_FILES = $(XMONAD_FILES:%=$(HOME)/.xmonad/%)

ALL_FILES = $(HOME_FILES) $(XMONAD_FILES)

CURRENTDIR=$(shell pwd)

install-xmonad: $(XMONAD_FILES)
	mkdir -p $(HOME)/.xmonad
	
	for i in $(XMONAD_FILES); do \
		install $(CURRENTDIR)/$$i $(HOME)/.xmonad/$$i; \
	done; \

install: $(ALL_FILES) install-xmonad
	for i in $(HOME_FILES); do \
		install $(CURRENTDIR)/$$i $(HOME)/.$$i; \
	done; \

uninstall: $(INSTALLED_XMONAD_FILES) $(INSTALLED_HOME_FILES)
	rm -f $^
