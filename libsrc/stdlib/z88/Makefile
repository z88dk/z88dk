#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.8 2006-06-18 14:55:44 dom Exp $

all: atol.o

atol.o:  atol.c
	zcc -Wn43 -vn -make-lib atol.c


clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i
