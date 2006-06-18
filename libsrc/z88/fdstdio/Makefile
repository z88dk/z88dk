#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2006-06-18 17:59:40 dom Exp $

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
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.o*  *.sym *.map zcc_opt.def *.i $(AFILES)
