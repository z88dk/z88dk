#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.6 2016-06-14 07:07:53 dom Exp $

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
	getcwd.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

z88_fcntl: $(OBJECTS)

.c.o:
	zcc +pps $(CFLAGS) $*.c


clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
