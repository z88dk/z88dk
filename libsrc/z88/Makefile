#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.9 2002-07-15 15:34:07 dom Exp $

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
	cd fdstdio ; $(MAKE)

z88: $(OBJECTS)
	z80asm -d -ns -nm -Mo -x../z88 @z88list

.c.o:
	zcc -vn -make-lib $*.c

clean:
	rm -f *.obj *.sym *.map *.o* *~ zcc_opt.def *.i $(AFILES)
	cd fdstdio ; $(MAKE) clean
