#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2014-06-04 20:37:27 stefano Exp $


include ../../Make.config

all: clock.o

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
