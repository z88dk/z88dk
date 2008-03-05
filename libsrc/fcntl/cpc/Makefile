#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2008-03-05 20:35:46 dom Exp $

include ../../Make.config

CFILES = \
	close.c      \
	cpc_openin.c \
	cpc_openout.c \
	open.c       \
	open_z88.c   \
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
