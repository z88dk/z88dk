#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2001-05-03 09:16:24 dom Exp $


all: blah z88

blah:
	cd fdstdio ; make

z88:	RegisterInt.o DeRegisterInt.o QueryPackage.o getpid.o nameapp.o \
	wcopen.o wcnext.o wcclose.o exec_cli.o stripdev.o strippath.o \
	openpopup.o openwindow.o opentitled.o
	z80asm -d -ns -nm -Mo -x../z88 @z88list

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f *.obj *.sym *.map *.o *~ zcc_opt.def
	cd fdstdio ; make clean
