#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.6 2006-06-18 17:59:37 dom Exp $


include ../../Make.config

all: 	strdup_far.o

.c.o:
	zcc $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def
	$(RM) strdup_far.asm *.i
