#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.7 2002-04-22 08:25:27 dom Exp $

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
	cd z88 ; make

zx_stdlib:
	cd spectrum ; make
	zcc +zx -vn -make-lib sleep.c

clean:
	rm -f *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; make clean
	cd spectrum ; make clean
