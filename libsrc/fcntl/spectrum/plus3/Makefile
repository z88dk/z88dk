#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.8 2016-06-13 19:55:47 dom Exp $

include ../../../Make.config

all:	close.o fabandon.o findhand.o freehand.o open.o \
	read.o readbyte.o write.o writebyte.o
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/p3 @p3list

.c.o:
	zcc +zx $(CFLAGS) -DPLUS3 $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

