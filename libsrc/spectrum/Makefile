#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.6 2008-03-25 12:48:12 stefano Exp $

include ../Make.config


all:	tape_save.o

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	cd beta ; $(RM) *.o* ; cd ..
	cd disciple ; $(RM) *.o* ; cd ..
	cd microdrive ; $(RM) *.o* ; cd ..
	cd opus ; $(RM) *.o* ; cd ..
