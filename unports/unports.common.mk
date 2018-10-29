PKG     ?= $(notdir $(shell pwd))
P        = $(PKG)
V        = $(VER)
PV       = $(P)-$(V)
SRCDIR   = work/$(PKGNAME)
PKGDIR  ?= $(HOME)/pkgs
PREFIX  ?= $(PKGDIR)/$(PKGNAME)
STOWDIR ?= $(HOME)/local

export PKGDIR
export SRCDIR
export PREFIX
export MAKEOPTS

.PHONY: all
all: build

.PHONY: patch
patch: extract work/.STAGE1_patch
work/.STAGE1_patch:
	$(PORTSDIR)/unports.scripts/patch
	@touch $@

.PHONY: configure
configure: patch work/.STAGE2_configure
work/.STAGE2_configure:
ifndef NO_BUILD
	$(PORTSDIR)/unports.scripts/configure
endif
	@touch $@

.PHONY: build
build: configure work/.STAGE3_build
work/.STAGE3_build:
ifndef NO_BUILD
	$(PORTSDIR)/unports.scripts/build
endif
	@touch $@

.PHONY: install
install: build $(PREFIX)
$(PREFIX): $(SRCDIR)
	$(PORTSDIR)/unports.scripts/install

.PHONY: clean distclean reset
clean: reset
	$(RM) -r $(SRCDIR)
distclean: clean reset
	$(RM) -r work/
reset:
	$(RM) work/.STAGE*

.PHONY: deinstall
deinstall: unmerge
	$(RM) -r $(PREFIX)

.PHONY: merge unmerge remerge
merge: install $(STOWDIR)
	cd $(PKGDIR) && stow -v -t $(STOWDIR) -S $(PKGNAME)
unmerge:
	if [ -d $(PREFIX) ]; then \
	    cd $(PKGDIR) && \
	    stow -v -t $(STOWDIR) -D $(PKGNAME); \
	fi
remerge: unmerge merge

work $(STOWDIR):
	mkdir $@
