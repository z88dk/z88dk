#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.18 2016-07-12 19:41:25 dom Exp $

include ../../../Make.config

CFILES = $(wildcard *.c)

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS) 

.c.o:
	$(ZCC) +z88 $(CFLAGS) $*.c

clean:
	$(RM) *.obj *.sym *.map *.o* *~ zcc_opt.def *.i $(AFILES)

