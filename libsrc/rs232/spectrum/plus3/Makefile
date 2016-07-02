#
# Wahey, a messed up makefile for building libraries!
# This version is valid for all the Spectrum 128 versions
# So it is now renamed to rs232plus.lib
#
# $Id: Makefile,v 1.11 2016-07-02 15:42:55 dom Exp $

include ../../../Make.config

CFILES = rs232_close.c rs232_get.c rs232_init.c rs232_params.c rs232_put.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/rs232plus @p3list

.c.o:  
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
