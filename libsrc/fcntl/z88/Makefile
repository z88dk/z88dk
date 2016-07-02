#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.9 2016-07-02 15:41:39 dom Exp $

include ../../Make.config

CFILES = \
	close.c      \
	creat.c      \
	lseek.c      \
	open.c       \
	read.c       \
	write.c      \
	writebyte.c  \
	readbyte.c   \
	stat.c       \
	opendor.c    \
	readdor.c    \
	closedor.c   \
	writedor.c   \
	deletedor.c  \
	sondor.c     \
	brotherdor.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	zcc +z88 $(CFLAGS) $*.c

clean:
	$(RM)  *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
