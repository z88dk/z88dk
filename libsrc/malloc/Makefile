#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2001-04-30 14:40:04 dom Exp $


all: malloc


malloc: calloc.o
	cd strings; make
	z80asm -d -ns -nm -Mo -x../malloc @malllist

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f *.o* *.sym *.map *~ *.err zcc_opt.def
	cd strings; make clean
