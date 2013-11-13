#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.22 2013-11-13 15:34:45 stefano Exp $

include ../Make.config

GENCFILES = \
	sleep.c   \
	csleep.c  \
	delay.c   \
	wcmatch.c \
	getopt.c


AFILES = $(GENCFILES:.c=.asm)
GENOBJECTS = $(GENCFILES:.c=.o)

lz88: deps z88_stdlib

lzx: deps zx_stdlib

lzx80: deps zx80_stdlib

lx1: deps x1_stdlib

lmc1000: deps mc1000_stdlib

losca: deps osca_stdlib

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

x1_stdlib:
	zcc +test -D__X1__ $(CFLAGS) *.c

mc1000_stdlib:
	zcc +test -D__MC1000__ $(CFLAGS) *.c

osca_stdlib:
	zcc +test -D__OSCA__ $(CFLAGS) *.c

# Rabbit Control Module and timer dependencies
deps:
	$(RM) delay.o
	$(RM) sleep.o
	$(RM) csleep.o
	$(RM) inp.o
	$(RM) outp_callee.o
	$(RM) randomize.o

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
	cd z88 ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
