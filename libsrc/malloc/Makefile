#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.9 2002-10-22 19:15:09 dom Exp $


all: malloc


malloc: calloc.o realloc_down.o
	cd strings; $(MAKE)
	z80asm -d -ns -nm -Mo -x../malloc @malllist

.c.o:
	zcc -vn -make-lib $*.c


clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i calloc.asm
	cd strings; $(MAKE) clean
