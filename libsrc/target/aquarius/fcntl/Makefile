#
# Makefile for +3 file support
#
# $Id: Makefile,v 1.9 2016-07-02 15:41:39 dom Exp $

include ../../../Make.config

CFILES = $(wildcard *.c)
AFILES = $(wildcard *.asm)
OBJECTS = $(CFILES:.c=.o) $(AFILES:.asm=.o)

all: $(OBJECTS)

%.o: %.c
	$(ZCC) +aquarius $(CFLAGS) -c -o $@ $<

%.o: %.asm
	$(ZCC) +aquarius $(CFLAGS) -c -o $@ $<


clean:
	$(RM) *.o* zcc_opt.def $(OUTPUT_DIRECTORY)/p3.lib
	

