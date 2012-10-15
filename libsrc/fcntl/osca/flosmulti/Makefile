#
# Makefile for OSCA FLOS file support
#
# $Id: Makefile,v 1.4 2012-10-15 10:40:46 stefano Exp $


include ../../../Make.config

all:	open.o open_z88.o close.o read.o readbyte.o write.o writebyte.o remove.o rename.o mkdir.o lseek.o fdtell.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/flosxdos @floslist

.c.o:
	zcc +osca $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

