#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.3 2002-10-22 19:15:14 dom Exp $


all: 	DsDisplayEllipse.o

.c.o:  
	zcc +rex -vn -make-lib $*.c


clean:
	$(RM) *.sym *.map zcc_opt.def *.o*
