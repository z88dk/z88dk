#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.11 2003-09-16 09:15:13 dom Exp $

GENCFILES = \
	atoi.c \
	itoa.c \
	strtol.c \
	strtoul.c \
	sleep.c   \
	getopt.c


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
	$(RM) *.o* *.sym *.map zcc_opt.def *.i 
	cd z88 ; $(MAKE) clean
	cd spectrum ; $(MAKE) clean
