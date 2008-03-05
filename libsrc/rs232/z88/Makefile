#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2008-03-05 20:35:47 dom Exp $

include ../../Make.config

CFILES = \
	rs232_close.c \
	rs232_get.c \
	rs232_init.c \
	rs232_params.c \
	rs232_put.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:  
	zcc +z88 $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
