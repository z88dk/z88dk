#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2002-10-03 20:07:18 dom Exp $

CFILES = \
	close.c      \
	creat.c      \
	lseek.c      \
	open.c       \
	open_z88.c   \
	read.c       \
	write.c      \
	writebyte.c  \
	readbyte.c   

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

z88_fcntl: $(OBJECTS)

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f  *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
