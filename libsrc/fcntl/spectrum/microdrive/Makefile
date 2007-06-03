#
# Makefile for ZX Microdrive file support
#
# $Id: Makefile,v 1.5 2007-06-03 15:13:06 stefano Exp $


include ../../../Make.config

all:	open.o open_z88.o close.o readbyte.o remove.o rename.o lseek.o tell.o
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/zxmdv @mdvlist

.c.o:
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

