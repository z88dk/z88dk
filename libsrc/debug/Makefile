#
# $Id: Makefile,v 1.1 2002-06-05 09:41:13 stefano Exp $

CFILES = dump.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all:	$(OBJECTS)
	z80asm -d -ns -nm -Mo -x../debug @debug.lst

.c.o:  
	zcc -vn -make-lib $*.c

clean:
	rm -f *.sym *.map zcc_opt.def *.o* *~ *.err *.i $(AFILES)
