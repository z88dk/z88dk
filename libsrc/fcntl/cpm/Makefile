#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2002-04-22 08:25:23 dom Exp $

CFILES = \
	_putoffset.c \
	bdos.c \
	close.c \
	creat.c \
	getfcb.c \
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

.c.o:
	zcc -vn -make-lib $*.c

clean:
	rm -f  *.sym *.map zcc_opt.def *.o* *~ *.i $(AFILES)
