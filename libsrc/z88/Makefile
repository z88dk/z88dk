#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.15 2008-03-05 20:35:48 dom Exp $

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
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/z88 @z88list

.c.o:
	zcc +z88 $(CFLAGS) $*.c

clean:
	$(RM) *.obj *.sym *.map *.o* *~ zcc_opt.def *.i $(AFILES)
	cd fdstdio ; $(MAKE) clean ; cd ..
