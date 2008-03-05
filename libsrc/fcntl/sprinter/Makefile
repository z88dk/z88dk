#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2008-03-05 20:35:46 dom Exp $

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
	zcc +pps $(CFLAGS) $*.c


clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
