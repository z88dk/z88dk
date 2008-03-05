#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.7 2008-03-05 20:35:46 dom Exp $


include ../../Make.config

all: 	strdup_far.o

.c.o:
	zcc +z88 $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def
	$(RM) strdup_far.asm *.i
