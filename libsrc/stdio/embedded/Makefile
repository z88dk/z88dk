# $Id: Makefile,v 1.1 2002-10-17 12:08:12 dom Exp $

CFILES = \
	ns16450.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	zcc -vn  -make-lib $*.c

clean:
	rm -f *.o* zcc_opt.def *.sym *.map *.i $(AFILES)
