#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2001-04-30 14:36:25 dom Exp $

all: atol.o

atol.o:  atol.c
	zcc  +z88 -Wn43 -vn -make-lib atol.c


clean:
	rm -f *.o* *.sym *.map zcc_opt.def
