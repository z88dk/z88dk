# $Id: Makefile,v 1.4 2002-04-22 08:25:26 dom Exp $

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
	zcc -vn -DNET_STDIO -make-lib $*.c

clean:
	rm -f *.o* zcc_opt.def *.sym *.map *.i $(AFILES)
