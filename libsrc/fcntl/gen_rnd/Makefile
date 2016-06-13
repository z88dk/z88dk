#
# Makefile for generic DOS file support
#
# $Id: Makefile,v 1.2 2016-06-13 19:55:47 dom Exp $


include ../../Make.config

all:	open.o  close.o lseek.o read.o write.o readbyte.o writebyte.o remove.o rename.o fdtell.o
	$(LIBLINKER) -x../../$(OUTPUT_DIRECTORY)/gendos @genlist

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

