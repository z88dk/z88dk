#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.9 2002-10-22 19:15:22 dom Exp $

GENCFILES = \
	atoi.c \
	itoa.c \
	strtol.c \
	strtoul.c 

ZXCFILES = $(GENCFILES) \
	sleep.c

AFILES  = $(ZXCFILES:.c=.asm)
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
	zcc +zx -vn -make-lib sleep.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; $(MAKE) clean
	cd spectrum ; $(MAKE) clean
