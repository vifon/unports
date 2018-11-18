PORTS = $(sort $(dir $(wildcard */Makefile)))

all: build

%:
	for port in $(PORTS); do $(MAKE) -C $$port $@; done
