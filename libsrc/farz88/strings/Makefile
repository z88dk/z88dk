#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2001-05-03 09:16:23 dom Exp $


all: 	strdup_far.o

.c.o:
	zcc -vn -make-lib $*.c

clean:
	rm -f *.o* *.sym *.map *~ *.err zcc_opt.def
