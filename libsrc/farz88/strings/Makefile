#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2002-10-22 19:15:03 dom Exp $


all: 	strdup_far.o

.c.o:
	zcc -vn -make-lib $*.c

clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def
	$(RM) strdup_far.asm *.i
