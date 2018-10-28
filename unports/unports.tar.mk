PORTSDIR = $(HOME)/ports

PKGNAME  = $(PV)
ARCHIVE ?= $(PKGNAME).tar.gz

include $(PORTSDIR)/unports.common.mk

.PHONY: fetch
fetch: work work/$(ARCHIVE)
work/$(ARCHIVE):
	wget $(URL) -O $@

.PHONY: extract
extract: fetch $(SRCDIR)
$(SRCDIR):
	cd work/ && tar zvxf $(ARCHIVE)
