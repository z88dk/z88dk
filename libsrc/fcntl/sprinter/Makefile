#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2002-10-22 19:15:06 dom Exp $

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
	$(RM) *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
