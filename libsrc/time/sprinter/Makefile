#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.6 2014-06-04 20:34:56 stefano Exp $

include ../../Make.config

all: clock.o time.o
    

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def *.asm
