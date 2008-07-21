#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.19 2008-07-21 10:09:26 stefano Exp $

include ../Make.config

GENCFILES = \
	sleep.c   \
	getopt.c


AFILES = $(GENCFILES:.c=.asm)
GENOBJECTS = $(GENCFILES:.c=.o)

lz88: rcmdeps z88_stdlib

lzx: rcmdeps zx_stdlib

generic: rcmdeps gen

gen: $(GENOBJECTS)

.c.o:
	zcc +test $(CFLAGS) $*.c

z88_stdlib:
	zcc +z88 $(CFLAGS) *.c
	cd z88  ; cd ..

zx_stdlib:
	zcc +zx $(CFLAGS) *.c
	cd spectrum  ; cd ..

rcmdeps:
	$(RM) inp.o
	$(RM) outp_callee.o
	$(RM) randomize.o

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
