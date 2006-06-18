#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.15 2006-06-18 17:59:40 dom Exp $

include ../Make.config

GENCFILES = \
	atoi.c \
	itoa.c \
	strtol.c \
	strtoul.c \
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
	cd z88 ; $(MAKE) ; cd ..

zx_stdlib:
	cd spectrum ; $(MAKE) ; cd ..

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
