#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2001-04-18 14:59:40 stefano Exp $


all: malloc


malloc:
	zcc -vn -make-lib calloc.c
	zcc -vn -make-lib strings/strdup.c
	cd strings; make
	z80asm -d -ns -nm -Mo -x../malloc @malllist


clean:
	rm -f *.o* *.sym *.map *~ *.err zcc_opt.def
	cd strings; make clean
