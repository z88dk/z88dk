#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.16 2016-05-16 20:05:18 dom Exp $

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

all: z88


z88: $(OBJECTS)
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/z88 @z88list

.c.o:
	zcc +z88 $(CFLAGS) $*.c

clean:
	$(RM) *.obj *.sym *.map *.o* *~ zcc_opt.def *.i $(AFILES)
