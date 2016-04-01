#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.29 2016-04-01 21:33:20 dom Exp $

include ../Make.config

CFILES = $(wildcard *.c) $(wildcard */*.c)

OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

z88/%.o: z88/%.c
	cd $(<D) ; zcc +z88 $(CFLAGS) $(<F) -o $(@F)

sprinter/%.o: sprinter/%.c
	cd $(<D) ; zcc +test $(CFLAGS) $(<F) -o $(@F)

x1/%.o: x1/%.c
	cd $(<D) ; zcc +test $(CFLAGS) $(<F) -o $(@F)

%.o: %.c
	zcc +test $(CFLAGS) $^ -o $@

clean:
	$(RM) *.o zcc_opt.def
	$(RM) */*.o */zcc_opt.def
