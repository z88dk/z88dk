#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.7 2002-10-22 19:15:23 dom Exp $

all: atol.o

atol.o:  atol.c
	zcc  +z88 -Wn43 -vn -make-lib atol.c


clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i
