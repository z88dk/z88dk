#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.7 2002-05-22 20:12:37 dom Exp $


all: malloc


malloc: calloc.o realloc_down.o
	cd strings; make
	z80asm -d -ns -nm -Mo -x../malloc @malllist

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f *.o* *.sym *.map *~ *.err zcc_opt.def *.i calloc.asm
	cd strings; make clean
