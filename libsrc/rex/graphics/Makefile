#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2002-01-18 12:06:40 dom Exp $


all: DsCircle.o DsEllipse.o Set4Pixels.o

.c.o:  
	zcc +rex -vn -make-lib $*.c


clean:
	rm -f *.sym *.map zcc_opt.def *.o*
