# $Id: Makefile,v 1.7 2008-03-05 20:35:48 dom Exp $

include ../../Make.config

CFILES = \
	closenet.c \
	fflush_net.c \
	fgetc_net.c \
	fputc_net.c \
	opennet.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: $(OBJECTS)

.c.o:
	zcc +z88 $(CFLAGS) -DNET_STDIO $*.c

clean:
	$(RM) *.o* zcc_opt.def *.sym *.map *.i $(AFILES)
