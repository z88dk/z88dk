#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2002-10-22 19:15:26 dom Exp $

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
	$(RM) *.o*  *.sym *.map zcc_opt.def *.i $(AFILES)
