#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2014-06-05 20:01:01 stefano Exp $


include ../../Make.config

all: time.o clock.o

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.i *.sym *.map zcc_opt.def
