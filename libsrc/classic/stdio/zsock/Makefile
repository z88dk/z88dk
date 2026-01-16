# $Id: Makefile,v 1.7 2008-03-05 20:35:48 dom Exp $

include ../../Make.config

CFILES = \
	fgetc_net.c \
	fputc_net.c \
	fopen_zsock.c  \
	zsock_trampoline.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	$(ZCC) +z88 $(CFLAGS) $*.c

clean:
	$(RM) *.o* zcc_opt.def *.sym *.map *.i $(AFILES)
