#
# $Id: Makefile,v 1.3 2006-06-18 14:55:43 dom Exp $

include ../Make.config

CFILES = dump.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	$(LIBLINKER) -x../debug @debug.lst

.c.o:  
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
