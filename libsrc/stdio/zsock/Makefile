# $Id: Makefile,v 1.6 2006-06-18 17:59:39 dom Exp $

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
	zcc $(CFLAGS) -DNET_STDIO $*.c

clean:
	$(RM) *.o* zcc_opt.def *.sym *.map *.i $(AFILES)
