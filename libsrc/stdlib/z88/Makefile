#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.9 2006-06-18 17:59:40 dom Exp $

include ../../Make.config

all: atol.o

atol.o:  atol.c
	zcc $(CFLAGS) atol.c


clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i
