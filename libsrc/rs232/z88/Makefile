#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2002-04-22 08:25:25 dom Exp $

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
	zcc -vn -make-lib $*.c

clean:
	rm -f *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
