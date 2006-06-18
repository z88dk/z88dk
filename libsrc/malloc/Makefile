#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.12 2006-06-18 14:55:44 dom Exp $

include ../Make.config

all: malloc


malloc: calloc.o realloc_down.o
	cd strings ; $(MAKE) ; cd ..
	$(LIBLINKER) -x../malloc @malllist

.c.o:
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i calloc.asm realloc_down.asm
	cd strings; $(MAKE) clean ; cd ..
