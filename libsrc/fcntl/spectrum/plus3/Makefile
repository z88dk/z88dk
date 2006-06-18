#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.5 2006-06-18 17:59:38 dom Exp $

include ../../../Make.config

all:	close.o fabandon.o findhand.o freehand.o open.o open_z88.o \
	read.o readbyte.o write.o writebyte.o
	$(LIBLINKER) -x../../../p3 @p3list

.c.o:
	zcc +zx $(CFLAGS) -DPLUS3 $*.c

clean:
	$(RM) *.o* zcc_opt.def
	

