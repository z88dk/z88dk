#
# Makefile for OSCA FLOS file support
#
# $Id: Makefile,v 1.1 2012-03-21 10:20:23 stefano Exp $


include ../../../Make.config

all:	open.o open_z88.o close.o readbyte.o writebyte.o remove.o rename.o lseek.o fdtell.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/flosxdos @floslist

.c.o:
	zcc +osca $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

