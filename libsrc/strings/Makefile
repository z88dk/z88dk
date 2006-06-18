#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.7 2006-06-18 17:59:40 dom Exp $

include ../Make.config

CFILES = \
	memchr.c \
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
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* *.i $(AFILES)
