#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2001-04-18 12:43:04 stefano Exp $

lz88: gen z88_stdlib

lzx: gen zx_stdlib

gen:
	zcc -vn -make-lib strtoul.c
	zcc -vn -make-lib strtol.c
	zcc -vn -make-lib atoi.c

z88_stdlib:
	cd z88 ; make

zx_stdlib:
	cd spectrum ; make


clean:
	rm -f *.o* *.sym *.map zcc_opt.def
	cd z88 ; make clean
	cd spectrum ; make clean
