PORTSDIR = $(HOME)/ports

PKGNAME ?= $(PV)-$(BRANCH)
BRANCH  ?= master
REPO    ?= $(P).git

include $(PORTSDIR)/unports.common.mk

.PHONY: fetch
fetch: work work/$(REPO)
work/$(REPO):
	git clone --bare $(URL) $@

.PHONY: extract
extract: fetch $(SRCDIR)
$(SRCDIR):
	git clone work/$(REPO) $@ -b $(BRANCH)
