#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.6 2002-04-22 08:25:27 dom Exp $

all: atol.o

atol.o:  atol.c
	zcc  +z88 -Wn43 -vn -make-lib atol.c


clean:
	rm -f *.o* *.sym *.map zcc_opt.def *.i
