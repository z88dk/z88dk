#
# $Id: Makefile,v 1.7 2008-03-05 20:35:46 dom Exp $

include ../Make.config

CFILES = dump.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/debug @debug.lst

.c.o:  
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
