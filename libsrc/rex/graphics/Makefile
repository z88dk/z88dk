#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.2 2002-04-10 20:20:22 dom Exp $


all: 	DsDisplayEllipse.o

.c.o:  
	zcc +rex -vn -make-lib $*.c


clean:
	rm -f *.sym *.map zcc_opt.def *.o*
