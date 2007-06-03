#
# $Id: Makefile,v 1.5 2007-06-03 15:13:05 stefano Exp $

include ../Make.config

CFILES = dump.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/debug @debug.lst

.c.o:  
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
