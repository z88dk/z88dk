# $Id: Makefile,v 1.5 2002-10-22 19:15:20 dom Exp $

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
	$(RM) *.o* zcc_opt.def *.sym *.map *.i $(AFILES)
