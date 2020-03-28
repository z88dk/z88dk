#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.9 2016-07-02 15:41:39 dom Exp $

include ../../../Make.config

CFILES = $(wildcard *.c)

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	$(ZCC) +z88 $(CFLAGS) $*.c

clean:
	$(RM)  *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
