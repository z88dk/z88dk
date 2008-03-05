#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.18 2008-03-05 20:35:48 dom Exp $

include ../Make.config

GENCFILES = \
	sleep.c   \
	getopt.c


AFILES = $(GENCFILES:.c=.asm)
GENOBJECTS = $(GENCFILES:.c=.o)

lz88: z88_stdlib

lzx: zx_stdlib

gen: $(GENOBJECTS)

.c.o:
	zcc +test $(CFLAGS) $*.c

z88_stdlib:
	zcc +z88 $(CFLAGS) *.c
	cd z88  ; cd ..

zx_stdlib:
	zcc +zx $(CFLAGS) *.c
	cd spectrum  ; cd ..

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
