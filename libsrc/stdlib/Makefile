#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2001-04-30 14:40:04 dom Exp $

lz88: gen z88_stdlib

lzx: gen zx_stdlib

gen: strtoul.o strtol.o atoi.o

c.o:
	zcc -vn -make-lib $*.c

z88_stdlib:
	cd z88 ; make

zx_stdlib:
	cd spectrum ; make


clean:
	rm -f *.o* *.sym *.map zcc_opt.def
	cd z88 ; make clean
	cd spectrum ; make clean
