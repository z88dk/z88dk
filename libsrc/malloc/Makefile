#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.10 2002-12-08 15:24:44 dom Exp $


all: malloc


malloc: calloc.o realloc_down.o
	cd strings; $(MAKE)
	z80asm -d -ns -nm -Mo -x../malloc @malllist

.c.o:
	zcc -vn -make-lib $*.c


clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i calloc.asm realloc_down.asm
	cd strings; $(MAKE) clean
