#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.13 2006-06-18 17:59:38 dom Exp $

include ../Make.config

all: malloc


malloc: calloc.o realloc_down.o 
	cd strings; $(MAKE); cd ..
	$(LIBLINKER) -x../malloc @malllist

.c.o:
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i calloc.asm realloc_down.asm strings/*.o strings/zcc_opt.def
	cd strings; $(MAKE) clean ; cd ..
