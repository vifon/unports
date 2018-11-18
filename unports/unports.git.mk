PORTSDIR = $(dir $(CURDIR))

PKGNAME ?= $(PV)-$(BRANCH)
BRANCH  ?= master
REPO    ?= $(P).git

include $(PORTSDIR)/unports.common.mk

.PHONY: fetch
fetch: work $(CURDIR)/work/$(REPO)
$(CURDIR)/work/$(REPO):
	git clone --bare $(URL) $@

.PHONY: extract
extract: fetch $(SRCDIR)
$(SRCDIR):
	git clone $(CURDIR)/work/$(REPO) $@ -b $(BRANCH)
