#
# Makefile for generic DOS file support
#
# $Id: Makefile,v 1.1 2014-01-14 07:48:40 stefano Exp $


include ../../Make.config

all:	open.o open_z88.o close.o lseek.o read.o write.o readbyte.o writebyte.o remove.o rename.o fdtell.o
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/gendos @genlist

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

