#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.7 2006-06-18 17:59:38 dom Exp $


include ../../Make.config

all:  strdup.o

.c.o:
	zcc $(CFLAGS) $*.c


clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i strdup.asm
