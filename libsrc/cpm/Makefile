#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2001-05-03 09:16:23 dom Exp $

all: bdos.o


.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f *.o* *.sym *.map zcc_opt.def
