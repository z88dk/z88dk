#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2002-04-22 08:25:27 dom Exp $

CFILES = \
	memcmp.c \
	memcpy.c \
	memset.c \
	strchr.c \
	strcspn.c \
	strlwr.c \
	strpbrk.c \
	strpos.c \
	strrchr.c \
	strrstrip.c \
	strspn.c \
	strstr.c \
	strupr.c

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: string

string: $(OBJECTS)

.c.o:  
	zcc -vn -Wn43 -make-lib $*.c

clean:
	rm -f *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
