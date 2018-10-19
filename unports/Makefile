PORTS = $(sort $(dir $(wildcard */Makefile)))

all: build

%:
	for port in $(PORTS); do make -C $$port $@; done
