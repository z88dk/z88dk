#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.14 2006-06-18 14:55:44 dom Exp $

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
	zcc -make-lib $*.c

z88_stdlib:
	cd z88 ; $(MAKE) ; cd ..

zx_stdlib:
	cd spectrum ; $(MAKE) ; cd ..

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
