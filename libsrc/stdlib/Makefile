#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.12 2003-09-16 19:00:34 denniz Exp $

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
	zcc -vn -make-lib $*.c

z88_stdlib:
	cd z88 ; $(MAKE)

zx_stdlib:
	cd spectrum ; $(MAKE)

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; $(MAKE) clean
	cd spectrum ; $(MAKE) clean
