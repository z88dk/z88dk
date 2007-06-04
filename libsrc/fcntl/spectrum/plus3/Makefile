#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.7 2007-06-04 05:54:11 stefano Exp $

include ../../../Make.config

all:	close.o fabandon.o findhand.o freehand.o open.o open_z88.o \
	read.o readbyte.o write.o writebyte.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/p3 @p3list

.c.o:
	zcc +zx $(CFLAGS) -DPLUS3 $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

