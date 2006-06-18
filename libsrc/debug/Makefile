#
# $Id: Makefile,v 1.4 2006-06-18 17:59:37 dom Exp $

include ../Make.config

CFILES = dump.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	$(LIBLINKER) -x../debug @debug.lst

.c.o:  
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
