#
# Makefile for ZX Microdrive file support
#
# $Id: Makefile,v 1.7 2009-01-12 12:27:11 stefano Exp $


include ../../../Make.config

all:	open.o open_z88.o close.o readbyte.o remove.o rename.o lseek.o fdtell.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/zxmdv @mdvlist

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

