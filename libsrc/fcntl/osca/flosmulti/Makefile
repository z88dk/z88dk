#
# Makefile for OSCA FLOS file support
#
# $Id: Makefile,v 1.5 2016-06-13 19:55:47 dom Exp $


include ../../../Make.config

all:	open.o close.o read.o readbyte.o write.o writebyte.o remove.o rename.o mkdir.o lseek.o fdtell.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/flosxdos @floslist

.c.o:
	zcc +osca $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

