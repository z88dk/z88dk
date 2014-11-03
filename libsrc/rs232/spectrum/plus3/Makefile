#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.9 2014-11-03 06:59:11 stefano Exp $

include ../../../Make.config

CFILES = rs232_close.c rs232_get.c rs232_init.c rs232_params.c rs232_put.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	$(LIBLINKER) -x../../../$(OUTPUT_DIRECTORY)/rs232plus @p3list

.c.o:  
	zcc +zx $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
