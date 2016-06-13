#
# Makefile for ZX Microdrive file support
#
# $Id: Makefile,v 1.8 2016-06-13 19:55:47 dom Exp $


include ../../../Make.config

all:	open.o close.o readbyte.o remove.o rename.o lseek.o fdtell.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/zxmdv @mdvlist

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

