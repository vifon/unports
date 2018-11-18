PORTSDIR = $(dir $(CURDIR))
ifeq ($(VER), git)
include $(PORTSDIR)/unports.git.mk
else
include $(PORTSDIR)/unports.tar.mk
endif
