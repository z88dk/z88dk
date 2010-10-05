#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.8 2010-10-05 06:33:45 stefano Exp $

include ../../Make.config

CFILES = \
	_putoffset.c \
	bdos.c \
	close.c \
	creat.c \
	fdtell.c \
	getfcb.c \
	lseek.c \
	open.c \
	open_z88.c \
	parsefcb.c \
	read.c \
	readbyte.c \
	remove.c \
	setfcb.c \
	write.c \
	writebyte.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

z88_fcntl: $(OBJECTS)

# It can't be +cpm, otherwise the bin output filename
# will be forced to 'a.com' !!
.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.i $(AFILES)
