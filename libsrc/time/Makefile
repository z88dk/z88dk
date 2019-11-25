#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.29 2016-04-01 21:33:20 dom Exp $

include ../Make.config

CFILES = $(wildcard *.c) $(wildcard */*.c)

OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

sprinter/%.o: sprinter/%.c
	@$(ZCC) +pps $(CFLAGS) $^ -o $@

x1/%.o: x1/%.c
	@$(ZCC) +x1 $(CFLAGS) $^ -o $@

%.o: %.c
	$(ZCC) +test $(CFLAGS) $^ -o $@

clean:
	@$(RM) *.o zcc_opt.def
	@$(RM) */*.o */zcc_opt.def
