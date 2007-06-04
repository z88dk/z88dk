#
# Makefile for ZX Microdrive file support
#
# $Id: Makefile,v 1.6 2007-06-04 05:54:11 stefano Exp $


include ../../../Make.config

all:	open.o open_z88.o close.o readbyte.o remove.o rename.o lseek.o tell.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/zxmdv @mdvlist

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

