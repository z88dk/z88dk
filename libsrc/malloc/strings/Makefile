#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.5 2002-10-22 19:15:09 dom Exp $


all:  strdup.o

.c.o:
	zcc -vn -make-lib $*.c


clean:
	$(RM) *.o* *.sym *.map *~ *.err zcc_opt.def *.i strdup.asm
