#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.4 2002-04-22 08:25:25 dom Exp $


all:  strdup.o

.c.o:
	zcc -vn -make-lib $*.c


clean:
	rm -f *.o* *.sym *.map *~ *.err zcc_opt.def *.i strdup.asm
