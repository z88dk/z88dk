#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2002-04-22 08:25:23 dom Exp $

CFILES = \
	close.c      \
	creat.c      \
	lseek.c      \
	open.c       \
	open_z88.c   \
	nropen.c     \
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

z88_fcntl: $(OBJECTS)

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f  *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
