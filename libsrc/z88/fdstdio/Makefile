#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2002-04-22 08:25:29 dom Exp $

CFILES = \
	fchkhdl.c \
	fdfread.c \
	fdfwrite.c \
	fdprintn.c \
	zfdopen.c \
	zfdopen_z88.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: fdstdio

fdstdio: $(OBJECTS)

.c.o:
	zcc -make-lib -vn $*.c

clean:
	rm -f *.o*  *.sym *.map zcc_opt.def *.i $(AFILES)
