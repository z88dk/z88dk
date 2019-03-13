#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.18 2016-07-12 19:41:25 dom Exp $

include ../../Make.config

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

all: $(OBJECTS) net

.c.o:
	$(ZCC) +z88 $(CFLAGS) $*.c

net:
	$(MAKE) -C net

clean:
	$(RM) *.obj *.sym *.map *.o* *~ zcc_opt.def *.i $(AFILES)
	$(MAKE) -C net clean

.PHONY: net
