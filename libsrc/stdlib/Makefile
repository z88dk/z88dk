#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.6 2001-10-16 20:33:14 dom Exp $

lz88: gen z88_stdlib

lzx: gen zx_stdlib

gen: strtoul.o strtol.o atoi.o itoa.o

.c.o:
	zcc -vn -make-lib $*.c

z88_stdlib:
	cd z88 ; make

zx_stdlib:
	cd spectrum ; make
	zcc +zx -vn -make-lib sleep.c


clean:
	rm -f *.o* *.sym *.map zcc_opt.def
	cd z88 ; make clean
	cd spectrum ; make clean
