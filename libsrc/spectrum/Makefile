#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.5 2007-10-02 14:13:48 stefano Exp $

include ../Make.config


all:	tape_save.o

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	cd disciple ; $(RM) *.o* ; cd ..
	cd microdrive ; $(RM) *.o* ; cd ..
	cd opus ; $(RM) *.o* ; cd ..
