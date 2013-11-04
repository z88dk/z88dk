#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.21 2013-11-04 08:57:56 stefano Exp $

include ../Make.config

GENCFILES = \
	sleep.c   \
	getopt.c


AFILES = $(GENCFILES:.c=.asm)
GENOBJECTS = $(GENCFILES:.c=.o)

lz88: deps z88_stdlib

lzx: deps zx_stdlib

lzx80: deps zx80_stdlib

generic: deps gen

gen: $(GENOBJECTS)

.c.o:
	zcc +test $(CFLAGS) *.c

z88_stdlib:
	zcc +z88 $(CFLAGS) *.c
	cd z88  ; cd ..

zx_stdlib:
	zcc +zx $(CFLAGS) *.c
	cd spectrum  ; cd ..

zx80_stdlib:
	zcc +zx80 $(CFLAGS) *.c

# Rabbit Control Module and timer dependencies
deps:
	$(RM) delay.o
	$(RM) sleep.o
	$(RM) csleep.o
	$(RM) sleep.o
	$(RM) inp.o
	$(RM) outp_callee.o
	$(RM) randomize.o

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
