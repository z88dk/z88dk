#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.9 2008-03-05 20:35:48 dom Exp $


include ../../Make.config

all: clock.o time.o

.c.o:
	zcc +z88 $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
