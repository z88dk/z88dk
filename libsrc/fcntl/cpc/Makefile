#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2003-09-12 16:30:41 dom Exp $

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
	zcc -vn -D__CPC__ -make-lib $*.c


clean:
	$(RM)  *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
