#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2016-06-13 19:55:46 dom Exp $

include ../../Make.config

CFILES = \
	close.c      \
	cpc_openin.c \
	cpc_openout.c \
	open.c       \
	read.c       \
	write.c      \
	writebyte.c  \
	readbyte.c   

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

cpc_fcntl: $(OBJECTS)

.c.o:
	zcc +cpc $(CFLAGS)  -D__CPC__  $*.c


clean:
	$(RM)  *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
