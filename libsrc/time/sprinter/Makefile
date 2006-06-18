#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2006-06-18 17:59:40 dom Exp $

include ../../Make.config

all: clock.o time.o
    

.c.o:
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def *.asm
