#
# Makefile for OSCA FLOS file support
#
# $Id: Makefile,v 1.3 2012-03-21 21:47:14 stefano Exp $


include ../../../Make.config

all:	open.o open_z88.o close.o read.o readbyte.o writebyte.o remove.o rename.o lseek.o fdtell.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/flosdos @floslist

.c.o:
	zcc +osca $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

