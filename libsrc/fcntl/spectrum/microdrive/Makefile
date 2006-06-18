#
# Makefile for ZX Microdrive file support
#
# $Id: Makefile,v 1.3 2006-06-18 14:55:43 dom Exp $


include ../../../Make.config

all:	open.o open_z88.o close.o readbyte.o remove.o rename.o lseek.o tell.o
	$(LIBLINKER) -x../../../zxmdv @mdvlist

.c.o:
	zcc +zx -vn -make-lib $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

