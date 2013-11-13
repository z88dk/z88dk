#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2013-11-13 20:46:42 stefano Exp $


include ../../Make.config

all: clock.o time.o

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
