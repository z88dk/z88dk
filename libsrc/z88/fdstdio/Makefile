#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2001-04-30 14:40:04 dom Exp $


all: fdstdio


fdstdio: fdfread.o fdfwrite.o fchkhdl.o fdprintn.o zfdopen.o zfdopen_z88.o

.c.o:
	zcc -make-lib -vn $*.c


clean:
	rm -f *.o*  *.sym *.map zcc_opt.def
