#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2002-10-22 19:15:15 dom Exp $

CFILES = rs232_close.c rs232_get.c rs232_init.c rs232_params.c rs232_put.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	z80asm -d -ns -nm -Mo -x../../../rs232if1 @if1list

.c.o:  
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
