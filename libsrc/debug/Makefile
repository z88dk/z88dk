#
# $Id: Makefile,v 1.2 2002-10-22 19:15:02 dom Exp $

CFILES = dump.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	z80asm -d -ns -nm -Mo -x../debug @debug.lst

.c.o:  
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
