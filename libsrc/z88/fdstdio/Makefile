#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.6 2008-03-05 20:35:48 dom Exp $

include ../../Make.config

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
	zcc +z88 $(CFLAGS) $*.c

clean:
	$(RM) *.o*  *.sym *.map zcc_opt.def *.i $(AFILES)
