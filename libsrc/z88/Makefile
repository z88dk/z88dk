#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.13 2006-06-18 17:59:40 dom Exp $

include ../Make.config

CFILES = \
	DeRegisterInt.c \
	exec_cli.c \
	fnexpand.c \
	getpid.c \
	nameapp.c \
	openpopup.c \
	opentitled.c \
	openwindow.c \
	QueryPackage.c \
	RegisterInt.c \
	stripdev.c \
	strippath.c \
	wcclose.c \
	wcnext.c \
	wcopen.c \

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: blah z88

blah:
	cd fdstdio ; $(MAKE) ; cd ..

z88: $(OBJECTS)
	$(LIBLINKER) -x../z88 @z88list

.c.o:
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.obj *.sym *.map *.o* *~ zcc_opt.def *.i $(AFILES)
	cd fdstdio ; $(MAKE) clean ; cd ..
