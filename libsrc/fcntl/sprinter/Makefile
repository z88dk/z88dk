#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2006-06-18 17:59:38 dom Exp $

include ../../Make.config

CFILES = \
	close.c      \
	creat.c      \
	lseek.c      \
	open.c       \
	open_z88.c   \
	read.c       \
	write.c      \
	writebyte.c  \
	readbyte.c   \
	getcwd.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

z88_fcntl: $(OBJECTS)

.c.o:
	zcc $(CFLAGS) $*.c


clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
