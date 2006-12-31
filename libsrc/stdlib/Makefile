#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.16 2006-12-31 22:13:19 aralbrec Exp $

include ../Make.config

GENCFILES = \
	sleep.c   \
	getopt.c


AFILES = $(GENCFILES:.c=.asm)
GENOBJECTS = $(GENCFILES:.c=.o)

lz88: gen z88_stdlib

lzx: gen zx_stdlib

gen: $(GENOBJECTS)

.c.o:
	zcc $(CFLAGS) $*.c

z88_stdlib:
	cd z88 ;  ; cd ..

zx_stdlib:
	cd spectrum ;  ; cd ..

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
